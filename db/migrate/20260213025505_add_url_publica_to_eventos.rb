class AddUrlPublicaToEventos < ActiveRecord::Migration[5.0]
  def change
    add_index :eventos, :guid, unique: true
  end
end
