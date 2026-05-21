class CheckDocumentosController < ApplicationController
  layout 'application_eventos'
  before_action :cargar_evento_contexto
  before_action :set_check_documento, only: [:show, :edit, :update, :destroy]

  def index
    @q = CheckDocumento.ransack(params[:q])
    @check_documentos = @q.result.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    respond_to { |format| format.html }
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @check_documento = CheckDocumento.new
    respond_to { |format| format.js }
  end

  def edit
    respond_to { |format| format.js }
  end

  def create
    @check_documento = CheckDocumento.new(check_documento_params)
    @check_documento.user_id = current_user.id
    respond_to do |format|
      if @check_documento.save
        @check_documentos = CheckDocumento.order(created_at: :desc)
        flash[:notice] = "Documento creado exitosamente."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @check_documento } }
      end
    end
  end

  def update
    respond_to do |format|
      if @check_documento.update(check_documento_params)
        flash[:notice] = "Documento actualizado exitosamente."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @check_documento } }
      end
    end
  end

  def destroy
    @check_documento.destroy
    flash[:success] = 'Documento eliminado exitosamente.'
    respond_to { |format| format.js }
  end

  private

  def set_check_documento
    @check_documento = CheckDocumento.find(params[:id])
  end

  # Mantiene el contexto del evento en el sidebar cuando se navega a la biblioteca
  # desde dentro de un evento específico
  def cargar_evento_contexto
    if params[:evento_guid].present?
      @evento = Evento.find_by_guid(params[:evento_guid])
    end
  end

  def check_documento_params
    params.require(:check_documento).permit(
      :titulo, :descripcion, :estado, :documento,
      :requiere_fecha_1, :fecha_actividad_1,
      :requiere_fecha_2, :fecha_actividad_2
    )
  end
end
