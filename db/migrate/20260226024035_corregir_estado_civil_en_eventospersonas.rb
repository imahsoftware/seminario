class CorregirEstadoCivilEnEventospersonas < ActiveRecord::Migration[5.0]
  def up
    # Agregar la columna FK
    add_column :eventospersonas, :estado_civil_id, :integer

    # Mapear datos existentes
    execute "UPDATE eventospersonas SET estado_civil_id = 1 WHERE estado_civil = 'SOLTERO'"
    execute "UPDATE eventospersonas SET estado_civil_id = 2 WHERE estado_civil = 'CASADO'"
    execute "UPDATE eventospersonas SET estado_civil_id = 3 WHERE estado_civil = 'UNION LIBRE'"
    execute "UPDATE eventospersonas SET estado_civil_id = 4 WHERE estado_civil = 'DIVORCIADO'"
    execute "UPDATE eventospersonas SET estado_civil_id = 5 WHERE estado_civil = 'VIUDO'"

    # Eliminar columna texto
    remove_column :eventospersonas, :estado_civil

    # Agregar índice
    add_index :eventospersonas, :estado_civil_id
  end

  def down
    add_column :eventospersonas, :estado_civil, :string, limit: 30
    remove_column :eventospersonas, :estado_civil_id
  end
end