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

    mensaje = "Hola #{eventopersona.acudiente_nombre}, soy del Seminario Redemptoris Mater. " \
      "#{eventopersona.nombre} se inscribio a un evento y necesita tu autorizacion. " \
      "Abre este enlace para autorizar: #{url_sms}"

    username = Parametro.find(31).valor
    password = Parametro.find(32).valor

    token = Base64.strict_encode64("#{username}:#{password}")
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
          mobile:           eventopersona.acudiente_celular.to_s,
          correlationLabel: nil,
          url:              url_sms.to_s
        }
      ]
    }

    Rails.logger.info "📱 SMS Autorizacion menor | Acudiente: #{eventopersona.acudiente_nombre} | Celular: #{eventopersona.acudiente_celular} | URL: #{url_sms}"

    http             = Net::HTTP.new(url.host, url.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request      = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json

    begin
      response      = http.request(request)
      response_body = response.body.to_s.force_encoding('UTF-8').scrub

      Rails.logger.info "✅ SMS Autorizacion menor | Respuesta Aldeamo: #{response.code} | #{response_body}"
      return response_body
    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.error "❌ SMS Autorizacion menor SSL Error | Celular: #{eventopersona.acudiente_celular} | #{e.message}"
      return nil
    rescue => e
      Rails.logger.error "❌ SMS Autorizacion menor Error | Celular: #{eventopersona.acudiente_celular} | #{e.message}"
      return nil
    end
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