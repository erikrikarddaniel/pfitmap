class RemoveColumnsFromEnzyme < ActiveRecord::Migration
  def up
    remove_column :enzymes, :name
    remove_column :enzymes, :parent_id
  end

  def down
    add_column :enzymes, :parent_id, :string
    add_column :enzymes, :name, :string
  end
end
