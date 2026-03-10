class CreateEventoseliminados < ActiveRecord::Migration[5.0]
  def change
    create_table :eventoseliminados do |t|
      t.integer  :evento_id
      t.integer  :eventospersona_id        # ID original antes de eliminar
      t.string   :identificacion
      t.string   :nombre
      t.string   :apellido
      t.string   :email
      t.string   :celular
      t.string   :tipo_persona
      t.date     :fecha_nacimiento
      t.integer  :eliminado_por_user_id    # quién lo eliminó
      t.string   :eliminado_por_nombre
      t.text     :datos_completos          # JSON con todo el registro
      t.timestamps
    end
  end
end
