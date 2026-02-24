class WssmsController < ApplicationController
  protect_from_forgery with: :null_session

  require 'uri'
  require 'net/https'
require "json"
require 'net/http'
require 'openssl'
require 'open-uri'

  require 'net/http'
  require 'uri'
  require 'json'
  require 'base64'

  def self.envio_sms_colombiaredenvio(eventopersona)

    mensaje = "Hola #{eventopersona.acudiente_nombre} Acudiente de  #{eventopersona.nombre} para completar la inscripción al evento debes abrir el siguiente enlace:"
    url_sms = "https://fd4f-186-80-30-23.ngrok-free.app/registro/#{eventopersona&.evento&.guid}/autorizacion/#{eventopersona&.id}"
    username = Parametro.find(31).valor
    password = Parametro.find(32).valor

    token = Base64.strict_encode64("#{username}:#{password}")
    url   = URI.parse('https://apitellit.aldeamo.com/SmsiWS/smsSendPost/')
    headers = {
      'Authorization' => "Basic #{token}",
      'Content-Type'  => 'application/json'
    }

    payload = {
      country: "57",
      dateToSend: nil,
      message: mensaje.to_s,
      encoding: "UTF-8",
      messageFormat: 0,
      addresseeList: [
        {
          mobile: eventopersona.acudiente_celular.to_s,
          correlationLabel: nil,
          url: url_sms.to_s
        }
      ]
    }

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json

    response = http.request(request)

    return response.body
  end


end