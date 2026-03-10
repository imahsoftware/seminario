class MenusController < ApplicationController
  layout :set_layout
  before_action :validatesession

  require 'rqrcode'

  def index
    if current_user.tipoconsulta == 'INSCRITO'
      redirect_to eventosperlistados_path and return
    end

    # ── NUEVO: SUPERVISOR ve solo sus eventos asignados ──────────────
    if current_user.tipoconsulta == 'SUPERVISOR'
      redirect_to eventos_responsable_index_path and return
    end
  end

  private

  def set_layout
    if ['PERSONA', 'METRO'].include?(User.find(is_admin).tipoconsulta.to_s)
      'application_admin'
    else
      'application_admin'
    end
  end
end