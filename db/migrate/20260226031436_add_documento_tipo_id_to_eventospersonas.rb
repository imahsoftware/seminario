class AddDocumentoTipoIdToEventospersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :eventospersonas, :documento_tipo_id, :integer
    add_index  :eventospersonas, :documento_tipo_id
  end
end