class AddHabeasDataParametroIdToEventos < ActiveRecord::Migration[5.0]
  def change
    add_column :eventos, :habeas_data_parametro_id, :integer
  end
end
