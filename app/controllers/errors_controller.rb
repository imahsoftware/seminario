class ErrorsController < ApplicationController
  # Las páginas de error deben ser públicas y a prueba de fallos:
  # si el visitante no estaba logueado (ej. registro público de eventos),
  # authenticate_user! reventaba aquí también y Rails devolvía el 500 plano
  # de emergencia (el archivo .txt que descargaba el navegador).
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :validatesession, raise: false
  skip_before_action :bloqueo_user_index, raise: false
  skip_before_action :verify_authenticity_token, raise: false

  layout 'login'

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.any  { render plain: 'Not Found', status: :not_found }
    end
  rescue StandardError
    render plain: 'Not Found', status: :not_found
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.any  { render plain: 'Internal Server Error', status: :internal_server_error }
    end
  rescue StandardError
    render plain: 'Internal Server Error', status: :internal_server_error
  end
end
