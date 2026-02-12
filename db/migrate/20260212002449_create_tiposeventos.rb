class CreateTiposeventos < ActiveRecord::Migration[5.0]
  def change
    create_table :tiposeventos do |t|
      t.string :descripcion
      t.string :estado, limit: 20
      t.references :user, foreign_key: true
      t.integer :user_act

      t.timestamps
    end
  end
end
