class AddHabeasDataToEventos < ActiveRecord::Migration[5.0]
  def change
    add_attachment :eventos, :habeas_data
  end
end
