class AddVoluntarioFieldsToEventospersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :eventospersonas, :es_voluntario,              :boolean, default: false
    add_column :eventospersonas, :acepta_autorizacion_datos,  :boolean, default: false
    add_column :eventospersonas, :acepta_cultura_cuidado,     :boolean, default: false
    add_column :eventospersonas, :acepta_autorizacion_menor,  :boolean, default: false
    add_column :eventospersonas, :iglesiascomunidad_apoyo_id, :integer
    add_column :eventospersonas, :apoyo_directo_seminario,    :boolean, default: false
    add_column :eventospersonas, :necesita_curso_alimentos,   :boolean, default: false
    add_column :eventospersonas, :fecha_curso_inicio,         :date
    add_column :eventospersonas, :fecha_curso_fin,            :date

    add_index :eventospersonas, :iglesiascomunidad_apoyo_id
  end
end
