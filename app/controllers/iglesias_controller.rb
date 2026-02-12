class IglesiasController < ApplicationController
  before_action :set_iglesia, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('iglesias')
  end

  def index
    @q = Iglesia.ransack(params[:q])
    @iglesias = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Iglesia.find(params[:active_id]) if params[:active_id].present?
    @iglesia = Iglesia.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Iglesia.find(params[:active_id]) if params[:active_id].present?
    @iglesia = Iglesia.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @iglesia = Iglesia.new(iglesia_params)
    respond_to do |format|
      if @iglesia.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesia } }
      end
    end
  end

  def update
    respond_to do |format|
      if @iglesia.update(iglesia_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iglesia } }
      end
    end
  end

  def destroy
    @iglesia.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_iglesia
    @iglesia = Iglesia.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def iglesia_params
    params.require(:iglesia).permit!
  end
end