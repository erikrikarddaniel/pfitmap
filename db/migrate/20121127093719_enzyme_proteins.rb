class EnzymeProteins < ActiveRecord::Migration
  def up
    remove_column :proteins, :enzyme_id
    create_table :enzyme_proteins do |t|
      t.integer :enzyme_id
      t.integer :protein_id

      t.timestamps
    end
  end
  def down
    drop_table :enzyme_proteins
    add_column :proteins, :enzyme_id, :integer
  end
end
