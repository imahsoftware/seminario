class CreateEventoCheckDocumentos < ActiveRecord::Migration[5.0]
  def change
    create_table :evento_check_documentos do |t|
      t.integer :evento_id,          null: false
      t.integer :check_documento_id, null: false
      t.integer :orden,              default: 0
      t.timestamps null: false
    end

    add_index :evento_check_documentos, :evento_id
    add_index :evento_check_documentos, :check_documento_id
    add_index :evento_check_documentos, [:evento_id, :check_documento_id], unique: true, name: 'idx_evento_check_unique'
  end
end
