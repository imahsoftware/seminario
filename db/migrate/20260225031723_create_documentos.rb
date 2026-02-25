class CreateDocumentos < ActiveRecord::Migration[5.0]
  def change
    create_table :documentos do |t|
      t.references :persona, null: false, foreign_key: true
      t.integer :tipo_documento_id, null: false

      # Campos para Paperclip (archivo de cédula frente y reverso)
      t.attachment :cedula_frente
      t.attachment :cedula_reverso

      t.timestamps
    end
  end
end
