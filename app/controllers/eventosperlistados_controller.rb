class EventosperlistadosController < ApplicationController
  before_action :authenticate_user!

  def index
    @inscripciones = Eventospersona.where(
      evento_id: current_user.eventos_inscritos.pluck(:id),
      persona_id: current_user.persona_id
    ).includes(:evento).order(created_at: :desc) || []
  end

  def cancelar
    @inscripcion = Eventospersona.find_by(
      id:         params[:id],
      persona_id: current_user.persona_id
    )

    if @inscripcion.nil?
      flash[:alert] = "Inscripción no encontrada."
      redirect_to eventosperlistados_path and return
    end

    if @inscripcion.evento.vencido?
      flash[:alert] = "No puedes cancelar un evento que ya terminó."
      redirect_to eventosperlistados_path and return
    end

    @inscripcion.eliminado_por = current_user
    if @inscripcion.destroy
      flash[:notice] = "Tu inscripción fue cancelada correctamente."
    else
      flash[:alert] = "No se pudo cancelar la inscripción."
    end

    redirect_to eventosperlistados_path
  end
end