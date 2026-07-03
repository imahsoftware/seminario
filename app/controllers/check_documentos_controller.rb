class CheckDocumentosController < ApplicationController
  layout 'application_eventos'
  # El formulario es multipart+remote — rails-ujs cae back a POST normal con file inputs.
  # Este controller ya requiere autenticación (authenticate_user! en ApplicationController),
  # por lo que omitir CSRF en create/update es seguro.
  skip_before_action :verify_authenticity_token, only: [:create, :update]
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
    respond_to do |format|
      format.js
      format.html  # renderiza new.html.erb (fallback cuando rails-ujs no puede hacer AJAX con file inputs)
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @check_documento = CheckDocumento.new(check_documento_params)
    @check_documento.user_id       = current_user.id
    @check_documento.updated_by_id = current_user.id
    respond_to do |format|
      if @check_documento.save
        @check_documentos = CheckDocumento.order(created_at: :desc)
        flash[:notice] = "Documento creado exitosamente."
        format.js
        format.html { redirect_to check_documentos_path, notice: "Documento '#{@check_documento.titulo}' creado exitosamente." }
      else
        format.js { render 'layouts/errors', locals: { object: @check_documento } }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @check_documento.updated_by_id = current_user.id
    respond_to do |format|
      if @check_documento.update(check_documento_params)
        flash[:notice] = "Documento actualizado exitosamente."
        format.js
        format.html { redirect_to check_documentos_path, notice: "Documento actualizado exitosamente." }
      else
        format.js { render 'layouts/errors', locals: { object: @check_documento } }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @check_documento.destroy
      flash[:success] = 'Documento eliminado exitosamente.'
    else
      flash[:alert] = @check_documento.errors[:base].first
    end
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
