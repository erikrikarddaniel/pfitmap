class CreateProteins < ActiveRecord::Migration
  def change
    create_table :proteins do |t|
      t.string :name
      t.string :rank
      t.references :HmmProfile
      t.references :Enzyme

      t.timestamps
    end
    add_index :proteins, :HmmProfile_id
    add_index :proteins, :Enzyme_id
  end
end
