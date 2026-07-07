class WssmsController < ApplicationController
  protect_from_forgery with: :null_session

  require 'uri'
  require 'net/https'
  require "json"
  require 'net/http'
  require 'openssl'
  require 'open-uri'
  require 'base64'

  def self.envio_sms_colombiaredenvio(eventopersona)
    dominio  = Parametro.find(37).valor
    url_sms  = "#{dominio}/registro/#{eventopersona&.evento&.guid}/autorizacion/#{eventopersona&.id}"

    mensaje = "Hola #{eventopersona.acudiente_nombre}, #{eventopersona.nombre} se inscribio y necesita tu autorizacion: #{url_sms}"

    # Blindaje: si por nombres largos se pasa de 160, se trunca el mensaje entero
    # (idealmente no debería pasar con este template, pero protege contra nombres muy largos)
    if mensaje.length > 160
      mensaje = mensaje[0, 157] + "..."
    end

    token = Parametro.find(31).valor

    url     = URI.parse('https://crwave.com.co/client/api/v1/sms/otp/')
    headers = {
      'Authorization' => "Token #{token}",
      'Content-Type'  => 'application/json'
    }
    payload = {
      phone_number: "57#{eventopersona.acudiente_celular}",
      message:      mensaje.to_s
    }.to_json

    Rails.logger.info "📱 SMS Autorizacion menor | Acudiente: #{eventopersona.acudiente_nombre} | Celular: #{eventopersona.acudiente_celular} | URL: #{url_sms}"

    http    = Net::HTTP.new(url.host, url.port).tap { |h| h.use_ssl = true }
    request = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload

    begin
      response      = http.request(request)
      code          = response.code.to_i
      response_body = response.body.to_s.force_encoding('UTF-8').scrub
      status        = response.is_a?(Net::HTTPSuccess) ? "Enviado" : "Error HTTP #{code}"

      Rails.logger.info "✅ SMS Autorizacion menor | Respuesta CRWave: #{code} | #{response_body}"
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      code          = nil
      response_body = e.message
      status        = "Timeout"
      Rails.logger.error "❌ SMS Autorizacion menor Timeout | Celular: #{eventopersona.acudiente_celular} | #{e.message}"
    rescue => e
      code          = nil
      response_body = e.message
      status        = "Exception: #{e.class}"
      Rails.logger.error "❌ SMS Autorizacion menor Error | Celular: #{eventopersona.acudiente_celular} | #{e.message}"
    ensure
    end

    { code: code, status: status, body: response_body }
  end


  def self.envio_sms_credenciales_inscrito(eventospersona, password)
    identificacion = eventospersona.identificacion.to_s

    mensaje = "Hola #{eventospersona.nombre}, te has inscrito exitosamente. " \
      "Ingresa a apps.srmmedellin.org con: " \
      "Usuario: #{identificacion} " \
      "Clave: #{password}"

    username     = Parametro.find(31).valor
    password_api = Parametro.find(32).valor

    token = Base64.strict_encode64("#{username}:#{password_api}")
    url   = URI.parse('https://apitellit.aldeamo.com/SmsiWS/smsSendPost/')

    headers = {
      'Authorization' => "Basic #{token}",
      'Content-Type'  => 'application/json'
    }

    payload = {
      country:       "57",
      dateToSend:    nil,
      message:       mensaje.to_s,
      encoding:      "UTF-8",
      messageFormat: 0,
      addresseeList: [
        {
          mobile:           eventospersona.celular.to_s,
          correlationLabel: nil,
          url:              nil
        }
      ]
    }

    http             = Net::HTTP.new(url.host, url.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request      = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json

    # ✅ Log antes de enviar
    Rails.logger.info "📱 SMS Credenciales | Enviando a: #{eventospersona.celular} | Usuario: #{identificacion}"

    begin
      response = http.request(request)

      # ✅ Log con respuesta del servidor
      Rails.logger.info "✅ SMS Credenciales | Enviado exitosamente a: #{eventospersona.celular} | Respuesta: #{response.body}"

      return response.body

    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.error "❌ SMS Credenciales SSL Error | Celular: #{eventospersona.celular} | Error: #{e.message}"
      return nil

    rescue => e
      Rails.logger.error "❌ SMS Credenciales Error | Celular: #{eventospersona.celular} | Error: #{e.message}"
      return nil
    end
  end

end