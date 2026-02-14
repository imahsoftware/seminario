class IglesiascomunidadesController < ApplicationController
  before_action :set_iglesia
  before_action :set_iglesiascomunidad, only: [:show, :edit, :update, :destroy]

  # GET /iglesiascomunidades
  # GET /iglesiascomunidades.json
  def index
    @iglesia = Iglesia.find(params[:iglesia_id])

    # Crear objeto Ransack para búsquedas
    @q = @iglesia.iglesiascomunidades.ransack(params[:q])

    # Obtener resultados filtrados
    @iglesiascomunidades = @q.result(distinct: true).order(:nombre).paginate(page: params[:page], per_page: 10)
  end


  # GET /iglesiascomunidades/1
  # GET /iglesiascomunidades/1.json
  def show
    @iglesia = Iglesia.find(params[:iglesia_id])
    @iglesiacomunidad = @iglesia.iglesiascomunidades.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # GET /iglesiascomunidades/new
  def new
    @iglesia = Iglesia.find(params[:iglesia_id])
    @iglesiacomunidad = @iglesia.iglesiascomunidades.build
  end


  # GET /iglesiascomunidades/1/edit
  def edit
    @iglesia = Iglesia.find(params[:iglesia_id])
    @iglesiacomunidad = @iglesia.iglesiascomunidades.find(params[:id])
  end


  # POST /iglesiascomunidades
  # POST /iglesiascomunidades.json
  def create
    @iglesia = Iglesia.find(params[:iglesia_id])
    @iglesiascomunidad = @iglesia.iglesiascomunidades.build(iglesiascomunidad_params)
    @iglesiascomunidad.user_id = is_admin
    respond_to do |format|
      if @iglesiascomunidad.save
        format.html { redirect_to @iglesia, notice: 'Registro creado correctamente.' }
        format.js   # si usas AJAX
      else
        format.html { render :new }
        format.js   { render :new }
      end
    end
  end


  # PATCH/PUT /iglesiascomunidades/1
  # PATCH/PUT /iglesiascomunidades/1.json
  def update
    @iglesiascomunidad.user_act = is_admin
    respond_to do |format|
      if @iglesiascomunidad.update(iglesiascomunidad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesiascomunidad } }

      end
    end
  end




  # DELETE /iglesiascomunidades/1
  # DELETE /iglesiascomunidades/1.json
  def destroy
    @iglesiascomunidad = @iglesia.iglesiascomunidades.find(params[:id])

    if @iglesiascomunidad.destroy
      flash[:success] = 'Eliminado con éxito'
    else
      flash[:error] = @iglesiascomunidad.errors.full_messages.to_sentence
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iglesiascomunidad
      @iglesiascomunidad = Iglesiascomunidad.find(params[:id])
    end

  def set_iglesia
    @iglesia = Iglesia.find(params[:iglesia_id])
  end
    # Only allow a list of trusted parameters through.
    def iglesiascomunidad_params
      params.require(:iglesiascomunidad).permit(:iglesia_id, :nombre, :estado, :user_id, :user_act)
    end
end
