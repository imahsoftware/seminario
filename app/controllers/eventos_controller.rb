class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_action :load_collections, only: [:new, :create, :edit, :update]

  # GET /eventos
  # GET /eventos.json
  def index
    if is_sygma
      @q = Evento.ransack(params[:q])
      @eventos = @q.result.paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_path
    end
  end

  # GET /eventos/1
  # GET /eventos/1.json
  def show
  end

  # GET /eventos/new
  def new
    @evento = Evento.new
  end

  # GET /eventos/1/edit
  def edit
  end

  # POST /eventos
  # POST /eventos.json
  def create
    @evento = Evento.new(evento_params)

    respond_to do |format|
      if @evento.save
        format.html { redirect_to @evento, notice: 'Evento was successfully created.' }
        format.json { render :show, status: :created, location: @evento }
      else
        format.html { render :new }
        format.json { render json: @evento.errors, status: :unprocessable_entity }
      end
    end
  end

  def load_collections
    @iglesias = Iglesia.order(:nombre)
    @iglesias_comunidad = Iglesiascomunidad.order(:nombre)
    @tipos_evento = Tiposevento.order(:descripcion)
  end

  # PATCH/PUT /eventos/1
  # PATCH/PUT /eventos/1.json
  def update
    respond_to do |format|
      if @evento.update(evento_params)
        format.html { redirect_to @evento, notice: 'Evento was successfully updated.' }
        format.json { render :show, status: :ok, location: @evento }
      else
        format.html { render :edit }
        format.json { render json: @evento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eventos/1
  # DELETE /eventos/1.json
  def destroy
    @evento.destroy
    respond_to do |format|
      format.html { redirect_to eventos_url, notice: 'Evento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evento
      @evento = Evento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def evento_params
      params.require(:evento).permit(:guid, :iglesia_id, :iglesiascomunidad_id, :tiposevento_id, :fecha_inicio, :fecha_fin, :detalle, :estado, :user_id, :user_act)
    end
end
