class AddCountedAccessionsAndAllAccessionsToProteinCount < ActiveRecord::Migration
  def change
    add_column :protein_counts, :counted_accessions, :text
    add_column :protein_counts, :all_accessions, :text
  end
end
