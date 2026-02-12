class CreateIglesias < ActiveRecord::Migration[5.0]
  def change
    create_table :iglesias do |t|
      t.string :nombre
      t.string :direccion
      t.string :telefono
      t.string :presbitero
      t.string :email
      t.references :user, foreign_key: true
      t.integer :user_act

      t.timestamps
    end
  end
end
