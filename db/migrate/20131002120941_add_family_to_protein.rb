class AddFamilyToProtein < ActiveRecord::Migration
  def change
    add_column :proteins, :family, :string
  end
end
