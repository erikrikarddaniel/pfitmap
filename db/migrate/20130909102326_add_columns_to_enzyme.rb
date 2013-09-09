class AddColumnsToEnzyme < ActiveRecord::Migration
  def change
    add_column :enzymes, :enzymeclass, :string
    add_column :enzymes, :subclass, :string
    add_column :enzymes, :group, :string
    add_column :enzymes, :subgroup, :string
    add_column :enzymes, :subsubgroup, :string
  end
end
