class CreateHmmDbHits < ActiveRecord::Migration
  def change
    create_table :hmm_db_hits do |t|
      t.integer :gi
      t.string :db
      t.string :acc
      t.string :desc

      t.timestamps
    end
    add_index :hmm_db_hits, :gi
    add_index :hmm_db_hits, [:db, :acc], unique: true
  end
end
