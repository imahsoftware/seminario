class WssmsController < ApplicationController
  protect_from_forgery with: :null_session

  require 'uri'
  require 'net/https'
  require "json"
  require 'net/http'
  require 'openssl'
  require 'open-uri'
  require 'base64'

  # ── SMS de autorización para menores de edad ────────────────────────────
  def self.envio_sms_colombiaredenvio(eventopersona)
    dominio  = Parametro.find(37).valor.to_s.chomp('/')
    url_sms  = "#{dominio}/registro/#{eventopersona&.evento&.guid}/autorizacion/#{eventopersona&.id}"

    # El link NUNCA debe recortarse: si el mensaje supera 160 caracteres,
    # se recorta el texto (los nombres), no la URL.
    prefijo     = "Hola #{eventopersona.acudiente_nombre}, #{eventopersona.nombre} se inscribio y necesita tu autorizacion: "
    max_prefijo = 160 - url_sms.length
    if prefijo.length > max_prefijo
      prefijo = max_prefijo > 30 ? "#{prefijo[0, max_prefijo - 5]}...: " : "Autorizacion: "
    end
    mensaje = prefijo + url_sms

    token = Parametro.find(31).valor

    url     = URI.parse('https://crwave.com.co/client/api/v1/sms/otp/')
    headers = { 'Authorization' => "Token #{token}", 'Content-Type' => 'application/json' }
    payload = { phone_number: "57#{eventopersona.acudiente_celular}", message: mensaje.to_s }.to_json

    Rails.logger.info "📱 SMS Autorizacion menor | Acudiente: #{eventopersona.acudiente_nombre} | Celular: #{eventopersona.acudiente_celular} | URL: #{url_sms}"

    http    = Net::HTTP.new(url.host, url.port).tap { |h| h.use_ssl = true }
    request = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload

    code = nil; response_body = nil; estado = 'ERROR'

    begin
      response      = http.request(request)
      code          = response.code.to_i
      response_body = response.body.to_s.force_encoding('UTF-8').scrub
      estado        = response.is_a?(Net::HTTPSuccess) ? 'ENVIADO' : 'ERROR'
      Rails.logger.info "✅ SMS Autorizacion menor | Respuesta CRWave: #{code} | #{response_body}"
    rescue => e
      response_body = e.message
      Rails.logger.error "❌ SMS Autorizacion menor Error | Celular: #{eventopersona.acudiente_celular} | #{e.message}"
    end

    # ── Guardar log ────────────────────────────────────────────────────────
    guardar_log(
      tipo:                 'AUTORIZACION_MENOR',
      evento_id:            eventopersona&.evento&.id,
      eventospersona_id:    eventopersona&.id,
      destinatario_nombre:  "#{eventopersona.acudiente_nombre}".strip,
      destinatario_celular: eventopersona.acudiente_celular.to_s,
      identificacion:       eventopersona.identificacion.to_s,
      mensaje:              mensaje,
      url_enviada:          url_sms,
      estado:               estado,
      codigo_http:          code,
      respuesta_servicio:   response_body
    )

    { code: code, status: estado, body: response_body }
  end

  # ── SMS de credenciales al inscrito ─────────────────────────────────────
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

    headers = { 'Authorization' => "Basic #{token}", 'Content-Type' => 'application/json' }
    payload = {
      country: "57", dateToSend: nil, message: mensaje.to_s,
      encoding: "UTF-8", messageFormat: 0,
      addresseeList: [{ mobile: eventospersona.celular.to_s, correlationLabel: nil, url: nil }]
    }

    http             = Net::HTTP.new(url.host, url.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request          = Net::HTTP::Post.new(url.request_uri, headers)
    request.body     = payload.to_json

    Rails.logger.info "📱 SMS Credenciales | Enviando a: #{eventospersona.celular} | Usuario: #{identificacion}"

    code = nil; response_body = nil; estado = 'ERROR'

    begin
      response      = http.request(request)
      code          = response.code.to_i
      response_body = response.body.to_s
      # Aldeamo devuelve status:0 en éxito dentro del JSON
      parsed = JSON.parse(response_body) rescue {}
      estado = (response.is_a?(Net::HTTPSuccess) && parsed['status'].to_i >= 0) ? 'ENVIADO' : 'ERROR'
      Rails.logger.info "✅ SMS Credenciales | Celular: #{eventospersona.celular} | Respuesta: #{response_body}"
    rescue => e
      response_body = e.message
      Rails.logger.error "❌ SMS Credenciales Error | Celular: #{eventospersona.celular} | #{e.message}"
    end

    # ── Guardar log ────────────────────────────────────────────────────────
    guardar_log(
      tipo:                 'CREDENCIALES',
      evento_id:            eventospersona&.evento_id,
      eventospersona_id:    eventospersona&.id,
      destinatario_nombre:  "#{eventospersona.nombre} #{eventospersona.apellido}".strip,
      destinatario_celular: eventospersona.celular.to_s,
      identificacion:       identificacion,
      mensaje:              mensaje,
      url_enviada:          nil,
      estado:               estado,
      codigo_http:          code,
      respuesta_servicio:   response_body
    )

    response_body
  end

  private

  def self.guardar_log(attrs)
    SmsLog.create!(attrs)
  rescue => e
    Rails.logger.error "❌ Error guardando SmsLog: #{e.message}"
  end
end
