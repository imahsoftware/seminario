  class MigrarEstadoCivilEnEventospersonas < ActiveRecord::Migration[5.0]
    def up
      add_column :eventospersonas, :estado_civil_id, :integer
      add_index  :eventospersonas, :estado_civil_id

      execute <<-SQL
      UPDATE eventospersonas SET estado_civil_id = 1 WHERE estado_civil = 'SOLTERO';
      UPDATE eventospersonas SET estado_civil_id = 2 WHERE estado_civil = 'CASADO';
      UPDATE eventospersonas SET estado_civil_id = 3 WHERE estado_civil = 'UNION LIBRE';
      UPDATE eventospersonas SET estado_civil_id = 4 WHERE estado_civil = 'DIVORCIADO';
      UPDATE eventospersonas SET estado_civil_id = 5 WHERE estado_civil = 'VIUDO';
    SQL

      remove_column :eventospersonas, :estado_civil
    end

    def down
      add_column :eventospersonas, :estado_civil, :string, limit: 30
      remove_column :eventospersonas, :estado_civil_id
    end
  end
