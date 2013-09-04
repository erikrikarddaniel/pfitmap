class RenameHmmDbHitToDbEntry < ActiveRecord::Migration
  def change
    rename_table :hmm_db_hits, :db_entries 
  end
end
