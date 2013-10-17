class RemoveNGenomesFromProteinCount < ActiveRecord::Migration
  def up
    remove_column :protein_counts, :no_genomes
  end

  def down
    add_column :protein_counts, :no_genomes, :integer
  end
end
