class AddParroquiaComunidadToEventospersonas < ActiveRecord::Migration[7.2]
  def change
    add_column :eventospersonas, :parroquia, :string, limit: 150
    add_column :eventospersonas, :comunidad,  :string, limit: 150
  end
end
