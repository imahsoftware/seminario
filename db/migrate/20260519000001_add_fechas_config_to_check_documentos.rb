class AddFechasConfigToCheckDocumentos < ActiveRecord::Migration[5.0]
  def change
    # ¿Este documento tiene fechas de actividad que el voluntario debe conocer?
    add_column :check_documentos, :requiere_fecha_1,    :boolean, default: false, null: false unless column_exists?(:check_documentos, :requiere_fecha_1)
    add_column :check_documentos, :fecha_actividad_1,   :date    unless column_exists?(:check_documentos, :fecha_actividad_1)
    add_column :check_documentos, :requiere_fecha_2,    :boolean, default: false, null: false unless column_exists?(:check_documentos, :requiere_fecha_2)
    add_column :check_documentos, :fecha_actividad_2,   :date    unless column_exists?(:check_documentos, :fecha_actividad_2)
  end
end
