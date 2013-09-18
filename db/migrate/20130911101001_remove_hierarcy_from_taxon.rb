class RemoveHierarcyFromTaxon < ActiveRecord::Migration
  def up
    remove_column :taxons, :hierarchy
  end

  def down
    add_column :taxons, :hierarchy, :string
  end
end
