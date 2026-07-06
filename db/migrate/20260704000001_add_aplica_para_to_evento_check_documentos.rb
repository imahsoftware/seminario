class AddAplicaParaToEventoCheckDocumentos < ActiveRecord::Migration[7.2]
  def change
    add_column :evento_check_documentos, :aplica_para, :string, limit: 10, default: 'AMBOS', null: false
  end
end
