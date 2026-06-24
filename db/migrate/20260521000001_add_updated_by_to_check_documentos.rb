class AddUpdatedByToCheckDocumentos < ActiveRecord::Migration[5.0]
  def change
    add_column :check_documentos, :updated_by_id, :integer unless column_exists?(:check_documentos, :updated_by_id)
    add_index  :check_documentos, :updated_by_id, name: 'index_check_documentos_on_updated_by_id' unless index_exists?(:check_documentos, :updated_by_id)
  end
end
