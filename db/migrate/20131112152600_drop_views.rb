class DropViews < ActiveRecord::Migration
  def up
    execute 'drop view protein_family_counts'
    execute 'drop view protein_class_counts'
    execute 'drop view protein_sub_class_counts'
    execute 'drop view protein_group_counts'
    execute 'drop view protein_sub_group_counts'
    execute 'drop view protein_sub_sub_group_counts'
  end

end
