class RemoveColumnsFromProtein < ActiveRecord::Migration
  def up
    remove_column :proteins, :name
    remove_column :proteins, :rank
  end

  def down
    add_column :proteins, :rank, :string
    add_column :proteins, :name, :string
  end
end
