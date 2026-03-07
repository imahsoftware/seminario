# app/controllers/registro_eventos_controller.rb
class RegistroEventosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create, :exito, :pendiente, :autorizacion, :vencido, :no_encontrado, :no_iniciado, :vigente, :sin_cupos, :autorizar_participacion, :buscar_persona, :no_autorizado]
  skip_before_action :verify_authenticity_token, only: [:create, :autorizar_participacion]
  layout 'registro_publico'

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

    # ── 1. Leer base64 de params ─────────────────────────────────────────────
    frente_b64     = params.dig(:eventospersona, :cedula_frente_base64)
    reverso_b64    = params.dig(:eventospersona, :cedula_reverso_base64)
    acu_frente_b64 = params.dig(:eventospersona, :acudiente_cedula_frente_base64)
    acu_rev_b64    = params.dig(:eventospersona, :acudiente_cedula_reverso_base64)

    # ── 2. Construir el modelo ───────────────────────────────────────────────
    @eventospersona = @evento.eventospersonas.build(eventospersona_params)

    # ── 3. Asignar fotos a attr_accessor ANTES del save ──────────────────────
    base64_a_paperclip(frente_b64,     'cedula_frente')          { |f| @eventospersona.cedula_frente          = f }
    base64_a_paperclip(reverso_b64,    'cedula_reverso')         { |f| @eventospersona.cedula_reverso         = f }
    base64_a_paperclip(acu_frente_b64, 'acudiente_cedula_frente'){ |f| @eventospersona.acudiente_cedula_frente = f }
    base64_a_paperclip(acu_rev_b64,    'acudiente_cedula_reverso'){ |f| @eventospersona.acudiente_cedula_reverso = f }

    # ── 4. Verificar si el titular ya tiene documentos ───────────────────────
    persona_existente = Persona.find_by(identificacion: @eventospersona.identificacion)
    if persona_existente && Documento.where(persona_id: persona_existente.id).exists?
      @eventospersona.ya_tiene_documentos = true
    end

    # ── 5. Verificar si el acudiente ya tiene documentos ────────────────────
    acu_identificacion = params.dig(:eventospersona, :acudiente_identificacion)
    if acu_identificacion.present?
      acudiente_existente = Persona.find_by(identificacion: acu_identificacion)
      if acudiente_existente && Documento.where(persona_id: acudiente_existente.id).exists?
        @eventospersona.acudiente_ya_tiene_documentos = true
      end
    end

    # ── 6. Guardar ───────────────────────────────────────────────────────────
    if @eventospersona.save

      # ── 7. Documento del titular ────────────────────────────────────────
      if @eventospersona.persona_id.present? && (frente_b64.present? || reverso_b64.present?)
        doc_titular = Documento.find_or_initialize_by(
          persona_id:       @eventospersona.persona_id,
          tipo_documento_id: @eventospersona.documento_tipo_id || 1
        )
        doc_titular.eventospersona_id = @eventospersona.id
        base64_a_paperclip(frente_b64,  'cedula_frente')  { |f| doc_titular.cedula_frente  = f }
        base64_a_paperclip(reverso_b64, 'cedula_reverso') { |f| doc_titular.cedula_reverso = f }
        unless doc_titular.save
          Rails.logger.error "❌ Error guardando Documento titular: #{doc_titular.errors.full_messages}"
        end
      end

      # ── 8. Redirección según edad ────────────────────────────────────────
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

      @frente_b64    = frente_b64
      @reverso_b64   = reverso_b64
      @acu_frente_b64 = acu_frente_b64
      @acu_rev_b64   = acu_rev_b64

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
    # Si ya fue respondida la vista misma muestra la guardia "no disponible"
  end

  # ── Procesar decisión del acudiente ─────────────────────────────────────
  def autorizar_participacion
    @evento         = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])

    # Guardia: si ya fue respondida no procesar de nuevo
    if @eventospersona.acudiente_firma.present?
      redirect_to autorizacion_registro_evento_path(@evento.guid, @eventospersona.id) and return
    end

    decision = params[:decision].to_s.upcase  # 'SI' o 'NO'

    if decision == 'SI'
      # ── Guardar documento del acudiente ──────────────────────────────────
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
        unless doc_acu.save
          Rails.logger.error "❌ Error guardando doc acudiente en autorización: #{doc_acu.errors.full_messages}"
        end

        # Actualizar tipo de documento en la persona acudiente
        if acu_tipo_id.present? && @eventospersona.acudiente_id.present?
          Persona.find_by(id: @eventospersona.acudiente_id)&.update(documento_tipo_id: acu_tipo_id)
        end
      end

      @eventospersona.update(acudiente_firma: 'SI')
      flash[:notice] = "La participación del menor ha sido autorizada correctamente."
      redirect_to exito_registro_evento_path(@evento.guid)

    else
      # NO autoriza
      @eventospersona.update(acudiente_firma: 'NO')
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

  def buscar_persona
    @evento = Evento.find_by_guid!(params[:guid])

    identificacion    = params[:identificacion].to_s.strip
    documento_tipo_id = params[:documento_tipo_id].to_s.strip

    persona = Persona.find_by(identificacion: identificacion, documento_tipo_id: documento_tipo_id)

    if persona
      documento = Documento.where(persona_id: persona.id).order(updated_at: :desc).first

      render json: {
        encontrada:          true,
        nombre:              persona.nombre,
        apellido:            persona.apellido,
        fecha_nacimiento:    persona.fecha_nacimiento&.strftime("%d/%m/%Y"),
        celular:             persona.celular,
        email:               persona.email,
        direccion:           persona.direccion,
        sexo:                persona.sexo,
        estado_civil_id:     persona.estado_civil_id,
        documento_tipo_id:   persona.documento_tipo_id,
        tiene_documentos:    documento.present?,
        cedula_frente_url:   documento&.cedula_frente&.url,
        cedula_reverso_url:  documento&.cedula_reverso&.url
      }
    else
      render json: { encontrada: false }
    end

  rescue ActiveRecord::RecordNotFound
    render json: { encontrada: false }
  end

  private

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
    params.require(:eventospersona).permit!
  end
end
