class AddEspecialFieldsToEventospersonas < ActiveRecord::Migration[7.2]
  def change
    # ── Campos comunes (adultos y menores) ────────────────────────────────────
    add_column :eventospersonas, :barrio,               :string, limit: 100
    add_column :eventospersonas, :municipio,            :string, limit: 100
    add_column :eventospersonas, :lugar_nacimiento,     :string, limit: 150
    add_column :eventospersonas, :ocupacion,            :string, limit: 150
    add_column :eventospersonas, :eps,                  :string, limit: 100

    # ── Área de voluntariado ──────────────────────────────────────────────────
    add_column :eventospersonas, :area_voluntariado,       :string, limit: 100
    add_column :eventospersonas, :area_voluntariado_otro,  :string, limit: 150

    # ── Contacto de emergencia (solo adultos voluntarios) ─────────────────────
    add_column :eventospersonas, :emergencia_nombre,    :string, limit: 100
    add_column :eventospersonas, :emergencia_apellido,  :string, limit: 100
    add_column :eventospersonas, :emergencia_telefono,  :string, limit: 30

    # ── Datos extendidos del acudiente (solo menores) ─────────────────────────
    add_column :eventospersonas, :acudiente_fecha_lugar_nacimiento, :string, limit: 200
    add_column :eventospersonas, :acudiente_direccion,              :string, limit: 200
    add_column :eventospersonas, :acudiente_barrio,                 :string, limit: 100
    add_column :eventospersonas, :acudiente_municipio,              :string, limit: 100
    add_column :eventospersonas, :acudiente_parroquia_comunidad,    :string, limit: 150
    add_column :eventospersonas, :acudiente_ocupacion,              :string, limit: 150
  end
end
