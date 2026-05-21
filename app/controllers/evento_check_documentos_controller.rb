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
    @ecd.update(orden: params[:orden])
    respond_to { |format| format.js { render 'refresh_documentos' } }
  end
end
