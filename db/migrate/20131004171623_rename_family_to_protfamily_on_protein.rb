class RenameFamilyToProtfamilyOnProtein < ActiveRecord::Migration
  def change
    rename_column :proteins, :family, :protfamily
  end
end
