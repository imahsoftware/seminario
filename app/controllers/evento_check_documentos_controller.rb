class EventoCheckDocumentosController < ApplicationController

  def create
    @evento = Evento.find(params[:evento_id])
    @ecd = @evento.evento_check_documentos.build(
      check_documento_id: params[:check_documento_id],
      orden: @evento.evento_check_documentos.count + 1
    )
    respond_to do |format|
      if @ecd.save
        format.js { render 'refresh_documentos' }
      else
        format.js { render js: "toastr.error('#{@ecd.errors.full_messages.join(', ')}');" }
      end
    end
  end

  def destroy
    @ecd = EventoCheckDocumento.find(params[:id])
    @evento = @ecd.evento
    @ecd.destroy
    respond_to { |format| format.js { render 'refresh_documentos' } }
  end

  def update
    @ecd = EventoCheckDocumento.find(params[:id])
    @evento = @ecd.evento
    attrs = {}
    attrs[:orden]       = params[:orden]       if params[:orden].present?
    attrs[:aplica_para] = params[:aplica_para] if params[:aplica_para].present?
    @ecd.update(attrs)
    respond_to { |format| format.js { render 'refresh_documentos' } }
  end
end
