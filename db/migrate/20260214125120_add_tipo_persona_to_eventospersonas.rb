class AddTipoPersonaToEventospersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :eventospersonas, :tipo_persona, :string, limit: 20
    add_index :eventospersonas, :tipo_persona
  end
end
