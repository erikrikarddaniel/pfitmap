class EnzymeProteins < ActiveRecord::Migration
  def change
    remove_column :proteins, :enzyme_id
    create_table :enzyme_proteins do |t|
      t.integer :enzyme_id
      t.integer :protein_id

      t.timestamps
    end
  end
end
