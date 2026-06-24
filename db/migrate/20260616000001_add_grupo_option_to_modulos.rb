class AddGrupoOptionToModulos < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:modulos, :grupo_option)
      add_column :modulos, :grupo_option, :string
    end
  end
end
