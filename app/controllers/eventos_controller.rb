class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy, :vertasas]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('eventos')
  end

  def index
    @q = Evento.ransack(params[:q])
    @eventos = @q.result.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @evento = Evento.new
    @evento.etapa = 'A'
    render "evento_form"
  end

  def edit
    if @evento.etapa.to_s == "B"
      @eventospersonas = @evento.eventospersonas.all
    end
    respond_to do |format|
      format.html { render :action => "evento_form" }
    end
  end

  def create
    @evento = Evento.new(evento_params)
    @evento.etapa = params[:etapa]
    @evento.user_id = is_admin
    if @evento.save
      flash[:notice] = "Creado con Exito."
      redirect_to edit_evento_path(@evento)
    else
      render "evento_form"
    end
  end

  def update
    @evento.user_act = is_admin
    if @evento.update(evento_params)
      flash[:notice] = "El registro ha sido actualizado con Exito."
      redirect_to edit_evento_path(@evento)
    else
      render "evento_form"
    end
  end

  def destroy
    @evento.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(eventos_url) }
      format.xml { head :ok }
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_eventos'
    else
      "application_admin"
    end
  end

  def set_evento
    params[:etapa].to_s != "" ? Evento.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @evento = Evento.find(params[:id])
  end

  def evento_params
    params.require(:evento).permit!
  end
end
