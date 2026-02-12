class CreateEventos < ActiveRecord::Migration[5.0]
  def change
    create_table :eventos do |t|
      t.string :guid
      t.references :iglesia, foreign_key: true
      t.references :iglesiascomunidad, foreign_key: true
      t.references :tiposevento, foreign_key: true
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :detalle
      t.string :estado, limit: 20
      t.references :user, foreign_key: true
      t.integer :user_act

      t.timestamps
    end
  end
end
