# app/controllers/eventos_controller.rb
class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy, :vertasas, :copiar_url]

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
      flash[:notice] = "Evento creado con éxito. URL de registro generada."
      redirect_to edit_evento_path(@evento)
    else
      render "evento_form"
    end
  end

  def update
    @evento.user_act = is_admin
    if @evento.update(evento_params)
      flash[:notice] = "El registro ha sido actualizado con Éxito."
      redirect_to edit_evento_path(@evento)
    else
      render "evento_form"
    end
  end

  def destroy
    @evento.destroy
    flash[:notice] = "El registro ha sido borrado con Éxito."
    respond_to do |format|
      format.html { redirect_to(eventos_url) }
      format.xml { head :ok }
    end
  end

  # Acción para copiar URL al portapapeles (AJAX)
  def copiar_url
    respond_to do |format|
      format.json { render json: { url: @evento.url_publica, success: true } }
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
    # Usar GUID en lugar de ID
    params[:etapa].to_s != "" ? Evento.find_by_guid!(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @evento = Evento.find_by_guid!(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Evento no encontrado"
    redirect_to eventos_path
  end

  def evento_params
    params.require(:evento).permit!
  end
end
