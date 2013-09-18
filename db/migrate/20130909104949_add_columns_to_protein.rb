class AddColumnsToProtein < ActiveRecord::Migration
  def change
    add_column :proteins, :protclass, :string
    add_column :proteins, :subclass, :string
    add_column :proteins, :group, :string
    add_column :proteins, :subgroup, :string
    add_column :proteins, :subsubgroup, :string
  end
end
