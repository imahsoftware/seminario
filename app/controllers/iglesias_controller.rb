class IglesiasController < ApplicationController
  before_action :set_iglesia, only: [:show, :edit, :update, :destroy]

  # GET /iglesias
  # GET /iglesias.json
  def index
        @q = Iglesia.ransack(params[:q])
        @iglesias = @q.result.paginate(:page => params[:page], :per_page => 10)
        respond_to do |format|
          format.html
        end
  end

  # GET /iglesias/1
  # GET /iglesias/1.json
  def show
    respond_to { |format| format.js }

  end

  # GET /iglesias/new
  def new
    @active_record = Iglesia.find(params[:active_id]) if params[:active_id].present?
    @iglesia = Iglesia.new
    respond_to { |format| format.js }
  end

  # GET /iglesias/1/edit
  def edit
    respond_to { |format| format.js }

  end

  # POST /iglesias
  # POST /iglesias.json
  def create
    @iglesia = Iglesia.new(iglesia_params)
    @iglesia.user_id = is_admin
    respond_to do |format|
      if @iglesia.save
        @iglesias = Iglesia.paginate(page: 1, per_page: 10)  # ✅ con paginación
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesia } }
      end
    end
  end

  # PATCH/PUT /iglesias/1
  # PATCH/PUT /iglesias/1.json
  def update
    @iglesia.user_act = is_admin
    respond_to do |format|
      if @iglesia.update(iglesia_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesia } }
      end
    end
  end

  # DELETE /iglesias/1
  # DELETE /iglesias/1.json
  def destroy
    @iglesia.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iglesia
      @iglesia = Iglesia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def iglesia_params
      params.require(:iglesia).permit(:nombre, :direccion, :telefono, :presbitero, :email, :user_id, :user_act)
    end
end
