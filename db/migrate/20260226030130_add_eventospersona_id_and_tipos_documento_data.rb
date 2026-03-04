class AddEventospersonaIdAndTiposDocumentoData < ActiveRecord::Migration[5.0]
  def up
    # Agregar eventospersona_id a documentos
    add_column :documentos, :eventospersona_id, :integer
    add_index  :documentos, :eventospersona_id

    # Insertar tipos de documento
    execute <<-SQL
      INSERT INTO documento_tipos (nombre, descripcion, estado, created_at, updated_at) VALUES
      ('CEDULA',    'Cédula de Ciudadanía',  'activo', NOW(), NOW()),
      ('TARJETA',   'Tarjeta de Identidad',  'activo', NOW(), NOW()),
      ('PASAPORTE', 'Pasaporte',             'activo', NOW(), NOW()),
      ('EXTRANJERIA','Cédula de Extranjería','activo', NOW(), NOW());
    SQL
  end

  def down
    remove_column :documentos, :eventospersona_id
    execute "DELETE FROM documento_tipos WHERE nombre IN ('CEDULA','TARJETA','PASAPORTE','EXTRANJERIA')"
  end
end