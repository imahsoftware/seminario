class CreateCheckDocumentos < ActiveRecord::Migration[5.0]
  def change
    create_table :check_documentos do |t|
      t.string  :titulo,       null: false
      t.text    :descripcion
      t.string  :estado,       default: 'ACTIVO'
      t.integer :user_id

      # Paperclip attachment
      t.string  :documento_file_name
      t.string  :documento_content_type
      t.bigint  :documento_file_size
      t.datetime :documento_updated_at

      t.timestamps null: false
    end

    add_index :check_documentos, :estado
    add_index :check_documentos, :user_id
  end
end
