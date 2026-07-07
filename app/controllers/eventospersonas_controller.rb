class EventospersonasController < ApplicationController
  before_action :set_eventospersona, only: [:show, :edit, :update, :destroy]

  # GET /eventospersonas
  # GET /eventospersonas.json
  def index
    @q = Eventospersona.ransack(params[:q])
    @eventospersonas = @q.result.paginate(:page => params[:page], :per_page => 50)
  end

  # GET /eventospersonas/1
  # GET /eventospersonas/1.json


  # GET /eventospersonas/new
  def new
    @eventospersona = Eventospersona.new
  end

  # GET /eventospersonas/1/edit
  # POST /eventospersonas
  # POST /eventospersonas.json
  def create
    @eventospersona = Eventospersona.new(eventospersona_params)

    respond_to do |format|
      if @eventospersona.save
        format.html { redirect_to @eventospersona, notice: 'Eventospersona was successfully created.' }
        format.json { render :show, status: :created, location: @eventospersona }
      else
        format.html { render :new }
        format.json { render json: @eventospersona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eventospersonas/1
  # PATCH/PUT /eventospersonas/1.json
  def show
    @ep = Eventospersona.find(params[:id])

    # Buscar documento igual que el código original
    persona    = Persona.find_by(identificacion: @ep.identificacion)
    @documento = persona ? Documento.find_by(persona_id: persona.id) : nil

    render partial: 'eventospersonas/modal_detalle', layout: false
  end

  def edit
    @ep = Eventospersona.find(params[:id])

    persona    = Persona.find_by(identificacion: @ep.identificacion)
    @documento = persona ? Documento.find_by(persona_id: persona.id) : nil

    render partial: 'eventospersonas/modal_editar', layout: false
  end

  # ── PATCH /eventospersonas/:id
  # Igual que tenías — responde JSON para el AJAX del formulario.
  def update
    @ep = Eventospersona.find(params[:id])

    if @ep.update(eventospersona_params)
      # ── Sincronizar checks de documentos ──────────────────────────────
      checks_params       = params.dig(:eventospersona, :checks)       || {}
      checks_fecha_params = params.dig(:eventospersona, :checks_fecha) || {}

      # Obtener IDs de checks disponibles para este evento
      ids_disponibles = @ep.evento.evento_check_documentos.pluck(:id).map(&:to_s)

      # Eliminar checks que fueron desmarcados
      ids_desmarcados = ids_disponibles.reject { |id| checks_params[id].to_s == "1" }
      @ep.eventospersona_checks
         .where(evento_check_documento_id: ids_desmarcados)
         .destroy_all

      # Crear/actualizar checks marcados
      checks_params.each do |ecd_id, valor|
        next unless valor.to_s == "1"
        ch = EventospersonaCheck.find_or_create_by(
          eventospersona_id:         @ep.id,
          evento_check_documento_id: ecd_id.to_i
        ) do |c|
          c.aceptado = true
        end
        # Guardar fecha elegida si aplica
        fecha_str = checks_fecha_params[ecd_id.to_s]
        if fecha_str.present?
          fecha_parsed = Date.strptime(fecha_str, '%d/%m/%Y') rescue nil
          ch.update_column(:fecha_1, fecha_parsed) if fecha_parsed
        elsif fecha_str == ''
          ch.update_column(:fecha_1, nil)
        end
      end
      # ──────────────────────────────────────────────────────────────────

      render json: { ok: true }, status: :ok
    else
      render json: { errors: @ep.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reenviar_mensaje
    @eventospersona = Eventospersona.find_by(id: params[:id])

    if @eventospersona.nil?
      respond_to do |format|
        format.json { render json: { ok: false, mensaje: 'Inscripción no encontrada' }, status: :not_found }
        format.html { redirect_back fallback_location: root_path, alert: 'Inscripción no encontrada' }
      end
      return
    end

    resultado = WssmsController.envio_sms_colombiaredenvio(@eventospersona)

    respond_to do |format|
      format.json do
        if resultado[:status] == 'ENVIADO'
          render json: { ok: true,  mensaje: "✅ SMS enviado al #{@eventospersona.acudiente_celular}" }
        else
          render json: { ok: false, mensaje: "❌ Error al enviar SMS: #{resultado[:body]}" }
        end
      end
      format.html do
        redirect_back fallback_location: root_path,
                      notice: "SMS reenviado al acudiente #{@eventospersona.acudiente_celular}"
      end
    end
  end


  # DELETE /eventospersonas/1
  # DELETE /eventospersonas/1.json
  def destroy
    # Guardar en tabla de eliminados antes de destruir
    @eventospersona.eliminado_por = current_user
    
    # El callback before_destroy del modelo se encargará de crear el registro en eventoseliminados
    
    if @eventospersona.destroy
      respond_to do |format|
        format.html { 
          redirect_back fallback_location: eventos_path, 
          notice: "#{@eventospersona.nombre} #{@eventospersona.apellido} fue eliminado correctamente y guardado en el historial." 
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { 
          redirect_back fallback_location: eventos_path, 
          alert: "No se pudo eliminar el registro: #{@eventospersona.errors.full_messages.join(', ')}" 
        }
        format.json { render json: @eventospersona.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eventospersona
      @eventospersona = Eventospersona.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def eventospersona_params
      params.require(:eventospersona).except(:checks, :checks_fecha).permit!
    end
end
