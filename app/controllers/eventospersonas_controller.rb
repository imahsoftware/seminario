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
      render json: { ok: true }, status: :ok
    else
      render json: { errors: @ep.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reenviar_mensaje
    @eventospersona = Eventospersona.find_by(id: params[:id])

    if @eventospersona.nil?
      redirect_back fallback_location: root_path,
                    alert: 'Inscripción no encontrada'
      return
    end

    WssmsController.envio_sms_colombiaredenvio(@eventospersona)
    redirect_back fallback_location: root_path,
                  notice: "SMS reenviado al acudiente #{@eventospersona.acudiente_celular}"
  end


  # DELETE /eventospersonas/1
  # DELETE /eventospersonas/1.json
  def destroy
    @eventospersona.destroy
    respond_to do |format|
      format.html { redirect_to eventospersonas_url, notice: 'Eventospersona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eventospersona
      @eventospersona = Eventospersona.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def eventospersona_params
      params.require(:eventospersona).permit!
    end
end
