class CreateEventospersonaChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :eventospersona_checks do |t|
      t.integer  :eventospersona_id,       null: false
      t.integer  :evento_check_documento_id, null: false
      t.boolean  :aceptado,                default: false
      t.datetime :fecha_aceptacion

      t.timestamps null: false
    end

    add_index :eventospersona_checks, :eventospersona_id
    add_index :eventospersona_checks, :evento_check_documento_id
    add_index :eventospersona_checks, [:eventospersona_id, :evento_check_documento_id],
              unique: true, name: 'idx_persona_check_unique'
  end
end
