class RemoveUniqueIndexOnHmmDbHit < ActiveRecord::Migration
  #Removes the index with unique true
  def up
    remove_index :hmm_db_hits, [:db, :acc]
    add_index :hmm_db_hits, [:db, :acc]
  end

  def down
    remove_index :hmm_db_hits, [:db, :acc]
    add_index :hmm_db_hits, [:db, :acc], unique: true
  end
end
