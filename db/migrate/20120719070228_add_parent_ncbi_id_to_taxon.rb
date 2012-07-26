class AddParentNcbiIdToTaxon < ActiveRecord::Migration
  def change
    add_index :taxons, :ncbi_taxon_id, :unique => true
    add_column :taxons, :parent_ncbi_id, :integer, :references => nil

  end
end
