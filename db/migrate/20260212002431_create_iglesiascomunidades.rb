class CreateIglesiascomunidades < ActiveRecord::Migration[5.0]
  def change
    create_table :iglesiascomunidades do |t|
      t.references :iglesia, foreign_key: true
      t.string :nombre
      t.string :estado, limit: 20
      t.references :user, foreign_key: true
      t.integer :user_act

      t.timestamps
    end
  end
end
