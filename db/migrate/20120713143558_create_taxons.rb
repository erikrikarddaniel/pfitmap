class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons, :id => false do |t|
      t.integer :ncbi_taxon_id, :primary_key
      t.string :name
      t.string :rank
      t.boolean :wgs
      t.integer :pfitmap_release_id

      t.timestamps
    end
    add_index :taxons, :pfitmap_release_id
  end
end
