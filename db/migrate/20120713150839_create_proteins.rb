class CreateProteins < ActiveRecord::Migration
  def change
    create_table :proteins do |t|
      t.string :name
      t.string :rank
      t.integer :hmm_profile_id
      t.integer :enzyme_id

      t.timestamps
    end
  end
end
