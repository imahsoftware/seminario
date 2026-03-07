class AddUpdatedByToEventospersonas < ActiveRecord::Migration[5.0]
  def change
    add_column :eventospersonas, :user_act, :integer
  end
end
