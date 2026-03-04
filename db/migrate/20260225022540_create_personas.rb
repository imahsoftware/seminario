class CreatePersonas < ActiveRecord::Migration[5.0]
  create_table :personas do |t|
    t.references :documento_tipo, null: false, foreign_key: true
    t.references :estado_civil, null: false, foreign_key: true

    t.string :identificacion, null: false
    t.string :nombre, null: false
    t.string :apellido, null: false
    t.date :fecha_nacimiento
    t.string :direccion
    t.string :celular
    t.string :email
    t.string :sexo

    t.timestamps
  end

  add_index :personas, [:documento_tipo_id, :identificacion], unique: true
end
