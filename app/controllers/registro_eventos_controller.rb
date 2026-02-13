# app/controllers/registro_eventos_controller.rb
class RegistroEventosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  layout 'registro_publico'

  # Muestra el formulario de registro público
  def show
    @evento = Evento.find_by_guid!(params[:guid])

    # Verificar estado del evento
    if @evento.vencido?
      render :vencido and return
    elsif @evento.no_iniciado?
      render :no_iniciado and return
    elsif !@evento.vigente?
      render :no_disponible and return
    end

    # Si el evento está vigente, mostrar formulario
    @eventospersona = @evento.eventospersonas.build

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  # Procesa el registro
  def create
    @evento = Evento.find_by_guid!(params[:guid])

    # Verificar vigencia nuevamente antes de guardar
    unless @evento.vigente?
      flash[:alert] = "El evento ya no está disponible para registro"
      redirect_to registro_evento_path(@evento.guid) and return
    end

    @eventospersona = @evento.eventospersonas.build(eventospersona_params)

    if @eventospersona.save
      flash[:notice] = "¡Registro exitoso! Gracias por inscribirte al evento."
      redirect_to exito_registro_evento_path(@evento.guid)
    else
      render :show
    end

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  # Página de confirmación de registro exitoso
  def exito
    @evento = Evento.find_by_guid!(params[:guid])
  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  private

  def eventospersona_params
    params.require(:eventospersona).permit!
  end
end
