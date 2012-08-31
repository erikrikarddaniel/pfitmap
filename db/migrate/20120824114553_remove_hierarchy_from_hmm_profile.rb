class RemoveHierarchyFromHmmProfile < ActiveRecord::Migration
  def up
    remove_column :hmm_profiles, :hierarchy
  end

  def down
    add_column :hmm_profiles, :hierarchy, :string
  end
end
