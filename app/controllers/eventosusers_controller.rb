class EventosusersController < ApplicationController
  before_action :set_eventosuser, only: [:show, :destroy]

  def index
    @eventosusers = Eventosuser.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eventosuser.find(params[:active_id]) if params[:active_id].present?
    @evento = Evento.find_by_guid!(params[:evento_id])  # ← GUID
    @eventosuser = Eventosuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eventosuser.find(params[:active_id]) if params[:active_id].present?
    @eventosuser = Eventosuser.find(params[:id])
    @evento = @eventosuser.evento
    respond_to { |format| format.js }
  end

  def create
    @evento = Evento.find_by_guid!(params[:evento_id])  # ← GUID
    @eventosuser = Eventosuser.new(eventosuser_params)
    @eventosuser.evento_id = @evento.id
    @eventosuser.user_id = is_admin
    respond_to do |format|
      if @eventosuser.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eventosuser } }
      end
    end
  end

  def update
    @eventosuser = Eventosuser.find(params[:id])
    @evento = @eventosuser.evento
    respond_to do |format|
      if @eventosuser.update(eventosuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eventosuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @eventosuser.destroy
  end

  private

  def set_eventosuser
    @evento = Evento.find_by_guid!(params[:evento_id])  # ← GUID
    @eventosuser = Eventosuser.find(params[:id]) if params[:id]
  end

  def eventosuser_params
    params.require(:eventosuser).permit!
  end
end