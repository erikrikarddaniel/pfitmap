class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      #schema-plus forces :references => nil to be added
      t.integer :ncbi_taxon_id, :references => nil
      t.string :name
      t.string :rank
      t.boolean :wgs

      t.timestamps
    end
  end
end
