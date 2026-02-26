# app/controllers/registro_eventos_controller.rb
class RegistroEventosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create , :exito, :pendiente, :autorizacion , :vencido , :no_encontrado , :no_iniciado , :vigente , :sin_cupos , :autorizar_participacion ]
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
    elsif @evento.lleno?
      render :sin_cupos and return
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

    if @eventospersona.save
      if @eventospersona.menor_de_edad?
        flash[:notice] = "Registro recibido. Pendiente autorización de acudiente."
        WssmsController.envio_sms_colombiaredenvio(@eventospersona)
        redirect_to pendiente_registro_evento_path(@evento.guid)
      else
        flash[:notice] = "¡Registro exitoso! Gracias por inscribirte al evento."
        redirect_to exito_registro_evento_path(@evento.guid)
      end

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

  def pendiente
    @evento = Evento.find_by_guid!(params[:guid])
  end


  def autorizacion
    @evento = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])
  end


  def autorizar_participacion
    @evento = Evento.find_by_guid!(params[:guid])
    @eventospersona = @evento.eventospersonas.find(params[:id])

    @eventospersona.update(
      acudiente_firma: 'SI',
    )

    flash[:notice] = "La participación del menor ha sido autorizada correctamente."
    redirect_to exito_registro_evento_path(@evento.guid)
  end

  private

  def eventospersona_params
    params.require(:eventospersona).permit!
  end
end
