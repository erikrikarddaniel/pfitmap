class RemoveIndexesFromTaxons < ActiveRecord::Migration
  def up 
   remove_index(:taxons, :name => 'index_taxons_on_ncbi_taxon_id')
  end

end
