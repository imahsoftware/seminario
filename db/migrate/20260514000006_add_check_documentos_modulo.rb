class AddCheckDocumentosModulo < ActiveRecord::Migration[5.0]
  def up
    # nivel 3 = Parametrización (donde viven tiposeventos, iglesias, etc.)
    execute <<-SQL
      INSERT INTO modulos (descripcion, controlador, nivel, grupo, grupo_option, created_at, updated_at)
      VALUES (
        'Biblioteca Documentos',
        '/check_documentos',
        3,
        'Parametrizacion',
        'parametro',
        NOW(),
        NOW()
      );
    SQL

    # Asignar el módulo a todos los usuarios administradores (geintac = 'S')
    modulo_id = Modulo.order(:id).last.id
    execute <<-SQL
      INSERT INTO usersmodulos (user_id, modulo_id, created_at, updated_at)
      SELECT id, #{modulo_id}, NOW(), NOW()
      FROM users
      WHERE geintac = 'S'
      AND id NOT IN (
        SELECT user_id FROM usersmodulos WHERE modulo_id = #{modulo_id}
      );
    SQL
  end

  def down
    modulo = Modulo.find_by(controlador: '/check_documentos')
    if modulo
      execute "DELETE FROM usersmodulos WHERE modulo_id = #{modulo.id};"
      modulo.destroy
    end
  end
end
