class AddEventoEspecialToEventos < ActiveRecord::Migration[5.0]
  def change
    add_column :eventos, :evento_especial, :boolean, default: false, null: false
  end
end
