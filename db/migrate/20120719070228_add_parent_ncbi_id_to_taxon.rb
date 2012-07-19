class AddParentNcbiIdToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :parent_ncbi_id, :integer, :references => [:taxons, :ncbi_taxon_id]

  end
end
