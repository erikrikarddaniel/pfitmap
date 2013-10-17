class RemoveColumnsFromTaxon < ActiveRecord::Migration
  def up
    remove_column :taxons, :name
    remove_column :taxons, :rank
    remove_column :taxons, :parent_ncbi_id
  end

  def down
    add_column :taxons, :parent_ncbi_id, :string
    add_column :taxons, :rank, :string
    add_column :taxons, :name, :string
  end
end
