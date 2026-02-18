# app/controllers/registro_eventos_controller.rb
class RegistroEventosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  layout 'registro_publico'

  def show
    @evento = Evento.find_by_guid!(params[:guid])

    if @evento.vencido?
      render :vencido and return
    elsif @evento.no_iniciado?
      render :no_iniciado and return
    elsif !@evento.vigente?
      render :no_disponible and return
    end

    @eventospersona = @evento.eventospersonas.build

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def create
    @evento = Evento.find_by_guid!(params[:guid])

    unless @evento.vigente?
      flash[:alert] = "El evento ya no está disponible para registro"
      redirect_to registro_evento_path(@evento.guid) and return
    end

    @eventospersona = @evento.eventospersonas.build(eventospersona_params)

    Rails.logger.info "📝 Intentando guardar eventospersona"
    Rails.logger.info "Fecha de nacimiento recibida: #{eventospersona_params[:fecha_nacimiento]}"
    Rails.logger.info "Es menor de edad: #{@eventospersona.menor_de_edad?}"
    Rails.logger.info "Edad: #{@eventospersona.calcular_edad}" if @eventospersona.fecha_nacimiento.present?
    byebug
    WssmsController.envio_sms_colombiaredenvio(@eventospersona)
    if @eventospersona.save
      flash[:notice] = "¡Registro exitoso! Gracias por inscribirte al evento."
      redirect_to exito_registro_evento_path(@evento.guid)
    else
      errores = @eventospersona.errors.full_messages

      Rails.logger.error "❌ Errores de validación:"
      errores.each { |error| Rails.logger.error "  - #{error}" }

      flash.now[:alert] = "Por favor, corrige los siguientes errores:"
      render :show
    end

  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end

  def exito
    @evento = Evento.find_by_guid!(params[:guid])
  rescue ActiveRecord::RecordNotFound
    render :no_encontrado
  end


  def autorizacion
  end
  private

  def eventospersona_params
    params.require(:eventospersona).permit!
  end
end
