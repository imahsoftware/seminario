# app/controllers/registro_eventos_controller.rb
class RegistroEventosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create, :exito, :pendiente, :autorizacion, :vencido, :no_encontrado, :no_iniciado, :vigente, :sin_cupos, :autorizar_participacion, :buscar_persona, :no_autorizado, :buscar_conyuge]
  skip_before_action :verify_authenticity_token, only: [:create, :autorizar_participacion]
  layout 'registro_publico'

  # ── Control global: ningún error imprevisto debe mostrar un 500 crudo ──────
  # Los rescue específicos dentro de cada acción siguen teniendo prioridad.
  rescue_from StandardError do |e|
    Rails.logger.error "❌ Error inesperado en registro público (#{action_name}): #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n") if e.backtrace
    respond_to do |format|
      format.html { render :error_interno, status: :internal_server_error }
      format.json { render json: { error: 'Error interno' }, status: :internal_server_error }
      format.any  { render plain: 'Error interno', status: :internal_server_error }
    end
  end

  # Declarado después de StandardError para que tenga prioridad (Rails evalúa
  # los rescue_from del más reciente al más antiguo).
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html { render :no_encontrado, status: :not_found }
      format.json { render json: { error: 'No encontrado' }, status: :not_found }
      format.any  { render plain: 'No encontrado', status: :not_found }
    end
  end

  def show
    @evento = Evento.find_by_guid!(params[:guid])

    if @evento.vencido?
      render :vencido and return
    elsif @evento.no_iniciado?
      render :no_iniciado and return
    elsif !@evento.vigente?
      render :no_disponible and return
    elsif @evento.lleno?
      render :sin_cupos and return
    end

    @eventospersona = @evento.eventospersonas.build

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def create
    @evento = Evento.find_by_guid!(params[:guid])

    unless @evento.vigente?
      flash[:alert] = "El evento ya no está disponible para registro"
      redirect_to registro_evento_path(@evento.guid) and return
    end

    frente_b64     = params.dig(:eventospersona, :cedula_frente_base64)
    reverso_b64    = params.dig(:eventospersona, :cedula_reverso_base64)
    acu_frente_b64 = params.dig(:eventospersona, :acudiente_cedula_frente_base64)
    acu_rev_b64    = params.dig(:eventospersona, :acudiente_cedula_reverso_base64)

    @eventospersona = @evento.eventospersonas.build(eventospersona_params)

    base64_a_paperclip(frente_b64,     'cedula_frente')           { |f| @eventospersona.cedula_frente           = f }
    base64_a_paperclip(reverso_b64,    'cedula_reverso')          { |f| @eventospersona.cedula_reverso          = f }
    base64_a_paperclip(acu_frente_b64, 'acudiente_cedula_frente') { |f| @eventospersona.acudiente_cedula_frente = f }
    base64_a_paperclip(acu_rev_b64,    'acudiente_cedula_reverso'){ |f| @eventospersona.acudiente_cedula_reverso = f }

    persona_existente = Persona.find_by(identificacion: @eventospersona.identificacion)
    if persona_existente && Documento.where(persona_id: persona_existente.id).exists?
      @eventospersona.ya_tiene_documentos = true
    end

    acu_identificacion = params.dig(:eventospersona, :acudiente_identificacion)
    if acu_identificacion.present?
      acudiente_existente = Persona.find_by(identificacion: acu_identificacion)
      if acudiente_existente && Documento.where(persona_id: acudiente_existente.id).exists?
        @eventospersona.acudiente_ya_tiene_documentos = true
      end
    end

    # ── Validar que voluntario sea mayor de edad ──────────────────────────────
    es_voluntario = params.dig(:eventospersona, :es_voluntario).to_s == "1"
    if es_voluntario
      fecha_nac_str = params.dig(:eventospersona, :fecha_nacimiento)
      if fecha_nac_str.present?
        fecha_nac = Date.parse(fecha_nac_str) rescue nil
        if fecha_nac && ((Date.today - fecha_nac).to_i / 365.25) < 18
          @eventospersona.errors.add(:base, "Los menores de edad no pueden registrarse como colaboradores/voluntarios.")
          @frente_b64     = frente_b64
          @reverso_b64    = reverso_b64
          @acu_frente_b64 = acu_frente_b64
          @acu_rev_b64    = acu_rev_b64
          flash.now[:alert] = "Por favor, corrige los siguientes errores:"
          render :show and return
        end
      end
    end
    # ──────────────────────────────────────────────────────────────────────────

    # ── Validar documentos si quiere ser voluntario ───────────────────────────
    if es_voluntario && @evento.evento_check_documentos.any?
      checks_recibidos  = params.dig(:eventospersona, :checks) || {}
      ids_requeridos    = @evento.evento_check_documentos.pluck(:id).map(&:to_s)
      faltantes         = ids_requeridos.reject { |id| checks_recibidos[id].to_s == "1" }

      if faltantes.any?
        @eventospersona.errors.add(:base, "Debes leer y aceptar todos los documentos requeridos para ser voluntario")

        @frente_b64     = frente_b64
        @reverso_b64    = reverso_b64
        @acu_frente_b64 = acu_frente_b64
        @acu_rev_b64    = acu_rev_b64

        flash.now[:alert] = "Por favor, corrige los siguientes errores:"
        render :show and return
      end
    end
    # ──────────────────────────────────────────────────────────────────────────

    if @eventospersona.save

      # ── Guardar evidencia de documentos aceptados ─────────────────────────
      checks_params       = params.dig(:eventospersona, :checks)       || {}
      checks_fecha_params = params.dig(:eventospersona, :checks_fecha) || {}

      checks_params.each do |ecd_id, valor|
        next unless valor.to_s == "1"
        ch = EventospersonaCheck.find_or_create_by(
          eventospersona_id:         @eventospersona.id,
          evento_check_documento_id: ecd_id.to_i
        ) do |c|
          c.aceptado = true
        end
        # Guardar la fecha elegida por el voluntario si aplica
        fecha_str = checks_fecha_params[ecd_id.to_s]
        if fecha_str.present?
          fecha_parsed = begin
            Date.strptime(fecha_str, '%d/%m/%Y')
          rescue ArgumentError, TypeError
            nil
          end
          ch.update_column(:fecha_1, fecha_parsed) if fecha_parsed
        end
      end
      # ──────────────────────────────────────────────────────────────────────

      if @eventospersona.conyuge_id.present?
        conyuge_anterior = @evento.eventospersonas
                                  .where(id: @eventospersona.conyuge_id)
                                  .where(conyuge_pendiente: 1)
                                  .first

        if conyuge_anterior
          conyuge_anterior.update_columns(
            conyuge_id:        @eventospersona.id,
            conyuge_pendiente: 'NO'
          )
        end
      end





      # ── NUEVO: Crear usuario INSCRITO automáticamente ──────────────────
      crear_usuario_inscrito(@eventospersona)
      # ──────────────────────────────────────────────────────────────────

      if @eventospersona.persona_id.present? && (frente_b64.present? || reverso_b64.present?)
        doc_titular = Documento.find_or_initialize_by(
          persona_id:        @eventospersona.persona_id,
          tipo_documento_id: @eventospersona.documento_tipo_id || 1
        )
        doc_titular.eventospersona_id = @eventospersona.id
        base64_a_paperclip(frente_b64,  'cedula_frente')  { |f| doc_titular.cedula_frente  = f }
        base64_a_paperclip(reverso_b64, 'cedula_reverso') { |f| doc_titular.cedula_reverso = f }
        begin
          unless doc_titular.save
            Rails.logger.error "❌ Error guardando Documento titular: #{doc_titular.errors.full_messages}"
          end
        rescue StandardError => e
          # Ej: Errno::EACCES si Paperclip no puede reemplazar un archivo viejo.
          # No debe impedir que se complete la inscripción.
          Rails.logger.error "❌ Excepción guardando Documento titular: #{e.class} - #{e.message}"
        end
      end

      if @eventospersona.menor_de_edad?
        begin
          WssmsController.envio_sms_colombiaredenvio(@eventospersona)
        rescue => e
          Rails.logger.error "Error enviando SMS: #{e.message}"
        end
        flash[:notice] = "Registro recibido. Pendiente autorización de acudiente."
        redirect_to pendiente_registro_evento_path(@evento.guid, @eventospersona.id)
      else
        flash[:notice] = "¡Registro exitoso! Gracias por inscribirte al evento."
        redirect_to exito_registro_evento_path(@evento.guid)
      end

    else
      errores = @eventospersona.errors.full_messages
      Rails.logger.error "❌ Errores de validación:"
      errores.each { |error| Rails.logger.error "  - #{error}" }

      @frente_b64     = frente_b64
      @reverso_b64    = reverso_b64
      @acu_frente_b64 = acu_frente_b64
      @acu_rev_b64    = acu_rev_b64

      flash.now[:alert] = "Por favor, corrige los siguientes errores:"
      render :show
    end

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def exito
    @evento = Evento.find_by_guid!(params[:guid])
  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def pendiente
    @evento         = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])
  end

  def autorizacion
    @evento         = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])
  end

  def autorizar_participacion
    @evento         = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])

    if @eventospersona.acudiente_firma.present?
      redirect_to autorizacion_registro_evento_path(@evento.guid, @eventospersona.id) and return
    end

    decision = params[:decision].to_s.upcase

    if decision == 'SI'
      acu_frente_b64 = params[:acudiente_cedula_frente_base64]
      acu_rev_b64    = params[:acudiente_cedula_reverso_base64]
      acu_tipo_id    = params[:acudiente_documento_tipo_id]

      if @eventospersona.acudiente_id.present? && (acu_frente_b64.present? || acu_rev_b64.present?)
        doc_acu = Documento.find_or_initialize_by(
          persona_id:        @eventospersona.acudiente_id,
          tipo_documento_id: acu_tipo_id.presence || 1
        )
        doc_acu.eventospersona_id = @eventospersona.id
        base64_a_paperclip(acu_frente_b64, 'acudiente_cedula_frente') { |f| doc_acu.cedula_frente  = f }
        base64_a_paperclip(acu_rev_b64,    'acudiente_cedula_reverso'){ |f| doc_acu.cedula_reverso = f }
        begin
          unless doc_acu.save
            Rails.logger.error "❌ Error guardando doc acudiente en autorización: #{doc_acu.errors.full_messages}"
          end
        rescue StandardError => e
          # Ej: Errno::EACCES si Paperclip no puede reemplazar un archivo viejo.
          # No debe impedir que se registre la autorización del acudiente.
          Rails.logger.error "❌ Excepción guardando doc acudiente en autorización: #{e.class} - #{e.message}"
        end

        if acu_tipo_id.present? && @eventospersona.acudiente_id.present?
          Persona.find_by(id: @eventospersona.acudiente_id)&.update(documento_tipo_id: acu_tipo_id)
        end
      end

      # update_column: la firma SIEMPRE debe quedar registrada, sin que
      # validaciones ajenas (ej. evento lleno) la bloqueen silenciosamente.
      @eventospersona.update_column(:acudiente_firma, 'SI')
      flash[:notice] = "La participación del menor ha sido autorizada correctamente."
      redirect_to exito_registro_evento_path(@evento.guid)

    else
      @eventospersona.update_column(:acudiente_firma, 'NO')
      redirect_to no_autorizado_registro_evento_path(@evento.guid)
    end

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def no_autorizado
    @evento = Evento.find_by_guid!(params[:guid])
  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def buscar_conyuge
    @evento = Evento.find_by!(guid: params[:guid])

    ep = @evento.eventospersonas
                .where(tipo_persona: 'MATRIMONIO')
                .find_by(identificacion: params[:identificacion].to_s.strip)

    if ep
      render json: {
        encontrado:     true,
        id:             ep.id,
        nombre_completo: "#{ep.nombre} #{ep.apellido}".strip,
        identificacion: ep.identificacion
      }
    else
      render json: {
        encontrado: false,
        mensaje:    'No se encontró ninguna persona inscrita con tipo MATRIMONIO y esa identificación en este evento.'
      }
    end
  end


  def buscar_persona
    @evento = Evento.find_by_guid!(params[:guid])

    identificacion    = params[:identificacion].to_s.strip
    documento_tipo_id = params[:documento_tipo_id].to_s.strip

    persona = if documento_tipo_id.present?
                Persona.find_by(identificacion: identificacion, documento_tipo_id: documento_tipo_id)
              else
                Persona.find_by(identificacion: identificacion)
              end

    # find_by en lugar de find, y protegido con &. para evitar nil
    eventospersona = Eventospersona.find_by(identificacion: identificacion)

    if persona
      documento = Documento.where(persona_id: persona.id).order(updated_at: :desc).first

      render json: {
        encontrada:         true,
        nombre:             persona.nombre,
        apellido:           persona.apellido,
        fecha_nacimiento:   persona.fecha_nacimiento&.strftime("%d/%m/%Y"),
        celular:            persona.celular,
        email:              persona.email,
        direccion:          persona.direccion,
        sexo:               persona.sexo,
        tipo_persona:       eventospersona&.tipo_persona,
        es_voluntario:      eventospersona&.es_voluntario == true,
        area_voluntariado:  eventospersona&.area_voluntariado.to_s,
        estado_civil_id:    persona.estado_civil_id,
        documento_tipo_id:  persona.documento_tipo_id,
        tiene_documentos:   documento.present?,
        cedula_frente_url:  documento&.cedula_frente&.url,
        cedula_reverso_url: documento&.cedula_reverso&.url
      }
    else
      render json: { encontrada: false }
    end

  rescue ActiveRecord::RecordNotFound
    render json: { encontrada: false }
  end
  private

  def crear_usuario_inscrito(ep)
    return if ep.identificacion.blank?

    password = ep.identificacion.to_s.ljust(8, '0')

    if User.exists?(identificacion: ep.identificacion)
      Rails.logger.info "ℹ️ Usuario ya existe para: #{ep.identificacion}, enviando SMS de todas formas"
    else
      email_usuario = if ep.email.present? && !User.exists?(email: ep.email)
                        ep.email
                      else
                        "#{ep.identificacion}@srmmedellin.org"
                      end

      user = User.new(
        email:                 email_usuario,
        username:              ep.identificacion,
        identificacion:        ep.identificacion,
        nombres:               ep.nombre,
        apellidos:             ep.apellido,
        nombre:                "#{ep.nombre} #{ep.apellido}",
        nombre_real:           "#{ep.nombre} #{ep.apellido}",
        celular:               ep.celular,
        tipoconsulta:          'INSCRITO',
        activo:                'S',
        estado:                'A',
        persona_id:            ep.persona_id,
        password:              password,
        password_confirmation: password
      )

      if user.save
        Rails.logger.info "✅ Usuario INSCRITO creado para identificacion: #{ep.identificacion}"
      else
        Rails.logger.warn "⚠️ No se pudo crear usuario #{ep.identificacion}: #{user.errors.full_messages}"
        return
      end
    end

    begin
      Rails.logger.info "📱 Enviando SMS credenciales a: #{ep.celular} | identificacion: #{ep.identificacion}"
      WssmsController.envio_sms_credenciales_inscrito(ep, password)
      Rails.logger.info "✅ SMS credenciales enviado exitosamente a: #{ep.celular}"
    rescue => e
      Rails.logger.error "❌ Error enviando SMS credenciales a #{ep.celular}: #{e.message}"
    end
  end
  # ───────────────────────────────────────────────────────────────────────






  def base64_a_paperclip(base64_data, prefix)
    return if base64_data.blank?

    tempfile = Tempfile.new([prefix, '.png'], Rails.root.join('tmp'))
    begin
      tempfile.binmode
      tempfile.write(Base64.decode64(base64_data))
      tempfile.rewind

      yield ActionDispatch::Http::UploadedFile.new(
        tempfile:     tempfile,
        filename:     "#{prefix}_#{Time.now.to_i}.png",
        content_type: 'image/png'
      )
    rescue => e
      Rails.logger.error "❌ base64_a_paperclip (#{prefix}): #{e.message}"
    ensure
      tempfile.close
      tempfile.unlink
    end
  end

  def eventospersona_params
    params.require(:eventospersona).except(:checks, :checks_fecha).permit!
  end

  def parsear_fecha_ddmmyyyy(str)
    return nil if str.blank?
    str = str.strip.gsub('-', '/')
    return nil unless str =~ /\A(\d{1,2})\/(\d{1,2})\/(\d{4})\z/
    d, m, y = $1.to_i, $2.to_i, $3.to_i
    Date.new(y, m, d) rescue nil
  end
end