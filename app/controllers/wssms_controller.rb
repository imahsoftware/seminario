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

    mensaje = "Hola #{eventopersona.acudiente_nombre}, soy del Seminario Redemptoris Mater. #{eventopersona.nombre} se inscribió a un evento y necesita tu autorización. Por favor abre este enlace para completar el proceso:"
    dominio  = Parametro.find(37).valor
    url_sms  = "#{dominio}/registro/#{eventopersona&.evento&.guid}/autorizacion/#{eventopersona&.id}"
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

    http             = Net::HTTP.new(url.host, url.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request      = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json

    begin
      response = http.request(request)
      return response.body
    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.error "SMS SSL Error: #{e.message}"
      return nil
    rescue => e
      Rails.logger.error "SMS Error: #{e.message}"
      return nil
    end
  end

  def self.envio_sms_credenciales_inscrito(eventospersona, password)
    identificacion = eventospersona.identificacion.to_s

    mensaje = "Hola #{eventospersona.nombre}, te has inscrito exitosamente. " \
      "Ingresa a apps.srmmedellin.org con: " \
      "Usuario: #{identificacion} " \
      "Clave: #{password}"

    username = Parametro.find(31).valor
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

    begin
      response = http.request(request)
      return response.body
    rescue OpenSSL::SSL::SSLError => e
      Rails.logger.error "SMS Credenciales SSL Error: #{e.message}"
      return nil
    rescue => e
      Rails.logger.error "SMS Credenciales Error: #{e.message}"
      return nil
    end
  end

end