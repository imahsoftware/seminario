class CreateEventosusers < ActiveRecord::Migration[5.0]
  def change
    create_table :eventosusers do |t|
      t.integer :evento_id
      t.integer :user_id
      t.integer :user_administra

      t.timestamps
    end
  end
end
