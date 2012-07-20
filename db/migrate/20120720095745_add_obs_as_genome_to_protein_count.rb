class AddObsAsGenomeToProteinCount < ActiveRecord::Migration
  def change
    add_column :protein_counts, :obs_as_genome, :boolean

  end
end
