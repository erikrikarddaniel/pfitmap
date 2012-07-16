class CreateProteinCounts < ActiveRecord::Migration
  def change
    create_table :protein_counts do |t|
      t.integer :no_genomes
      t.integer :no_proteins
      t.integer :no_genomes_with_proteins
      t.references :protein
      t.references :pfitmap_release
      t.references :taxon

      t.timestamps
    end
  end
end
