class CreateEstadoCiviles < ActiveRecord::Migration[5.0]
  def change
    create_table :estado_civiles do |t|
      t.string :nombre
      t.string :estado

      t.timestamps
    end
  end
end
