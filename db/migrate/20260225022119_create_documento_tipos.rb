class CreateDocumentoTipos < ActiveRecord::Migration[5.0]
  def change
    create_table :documento_tipos do |t|
      t.string :nombre, null: false
      t.string :descripcion
      t.string :estado, default: 'activo'

      t.timestamps
    end

    add_index :documento_tipos, :nombre, unique: true
  end
end
