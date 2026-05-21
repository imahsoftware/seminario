class AddFechasToEventospersonaChecks < ActiveRecord::Migration[5.0]
  def change
    # Fechas que ingresa el voluntario al aceptar un documento que las requiere
    add_column :eventospersona_checks, :fecha_1, :date unless column_exists?(:eventospersona_checks, :fecha_1)
    add_column :eventospersona_checks, :fecha_2, :date unless column_exists?(:eventospersona_checks, :fecha_2)
  end
end
