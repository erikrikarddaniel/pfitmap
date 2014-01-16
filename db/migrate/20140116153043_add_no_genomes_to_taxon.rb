class AddNoGenomesToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :no_genomes, :integer
  end
end
