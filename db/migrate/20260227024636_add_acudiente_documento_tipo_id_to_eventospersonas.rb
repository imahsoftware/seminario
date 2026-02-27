class AddAcudienteDocumentoTipoIdToEventospersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :eventospersonas, :acudiente_documento_tipo_id, :integer
    add_index  :eventospersonas, :acudiente_documento_tipo_id
  end
end