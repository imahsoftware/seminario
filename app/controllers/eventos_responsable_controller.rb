# app/controllers/eventos_responsable_controller.rb
class EventosResponsableController < ApplicationController
  before_action :authenticate_user!

  def index
    @eventos = current_user.eventos_responsable.order(created_at: :desc)
  end

  def show
    @evento = current_user.eventos_responsable.find_by!(guid: params[:id])

    @q = @evento.eventospersonas.ransack(params[:q])
    resultado_completo = @q.result(distinct: true)

    hoy = Date.today

    @total_inscritos  = resultado_completo.count
    @total_menores    = resultado_completo.where("fecha_nacimiento > ?", hoy - 18.years).count
    @total_mayores    = resultado_completo.where("fecha_nacimiento <= ?", hoy - 18.years).count
    @sin_fecha        = resultado_completo.where(fecha_nacimiento: nil).count

    autorizados_q    = resultado_completo.joins(:evento).where(
      "fecha_nacimiento > ? AND acudiente_firma = 'SI'", hoy - 18.years
    )
    no_autorizados_q = resultado_completo.joins(:evento).where(
      "fecha_nacimiento > ? AND acudiente_firma = 'NO'", hoy - 18.years
    )
    pendientes_q     = resultado_completo.where(
      "fecha_nacimiento > ? AND (acudiente_firma IS NULL OR acudiente_firma = '')",
      hoy - 18.years
    )

    @autorizados    = autorizados_q.count
    @no_autorizados = no_autorizados_q.count
    @pendientes     = pendientes_q.count

    @eventospersonas = resultado_completo
                         .order('created_at desc')
                         .paginate(page: params[:page], per_page: 10)

    identificaciones = @eventospersonas.map(&:identificacion).compact.uniq
    personas_map     = Persona.where(identificacion: identificaciones).index_by(&:identificacion)
    persona_ids      = personas_map.values.map(&:id)
    documentos_map   = Documento.where(persona_id: persona_ids).index_by(&:persona_id)
    @documentos_por_identificacion = personas_map.transform_values { |p| documentos_map[p.id] }

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Evento no encontrado o no tienes acceso."
    redirect_to eventos_responsable_index_path
  end

  private


end