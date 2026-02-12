class CreateEventospersonas < ActiveRecord::Migration[5.0]
  def change
    create_table :eventospersonas do |t|
      t.references :evento, foreign_key: true
      t.string :identificacion, limit: 20
      t.string :nombre
      t.string :apellido
      t.date :fecha_nacimiento
      t.string :direccion
      t.string :celular, limit: 20
      t.string :email
      t.string :sexo, limit: 10
      t.string :estado_civil, limit: 30
      t.string :acudiente_nombre
      t.string :acudiente_apellido
      t.string :acudiente_identificacion, limit: 30
      t.string :acudiente_email
      t.string :acudiente_celular, limit: 20
      t.string :acudiente_codigoval, limit: 10
      t.string :acudiente_codigorec, limit: 10
      t.string :acudiente_firma
      t.string :acepta_politica, limit: 2
      t.string :acepta_cultura, limit: 2

      t.timestamps
    end
  end
end
