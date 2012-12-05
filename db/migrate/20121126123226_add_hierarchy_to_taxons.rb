class AddHierarchyToTaxons < ActiveRecord::Migration
  def change
    add_column :taxons, :hierarchy, :text, :null => :false
    add_index :taxons, :hierarchy
  end
end
