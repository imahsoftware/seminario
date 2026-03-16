class TiposeventosController < ApplicationController
  before_action :set_tiposevento, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposeventos')
  end

  def index
    @q = Tiposevento.ransack(params[:q])
    @tiposeventos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposevento.find(params[:active_id]) if params[:active_id].present?
    @tiposevento = Tiposevento.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposevento.find(params[:active_id]) if params[:active_id].present?
    @tiposevento = Tiposevento.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposevento = Tiposevento.new(tiposevento_params)
    respond_to do |format|
      if @tiposevento.save
        @tiposeventos = Tiposevento.all  # ✅ necesario para el render 'tabla'
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposevento } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposevento.update(tiposevento_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposevento } }
      end
    end
  end

  def destroy
    @tiposevento.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposevento
    @tiposevento = Tiposevento.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposevento_params
    params.require(:tiposevento).permit!
  end
end