class AddColumnBestHmmProfile < ActiveRecord::Migration
  def up
    add_column :db_sequences, :best_hmm_profile_id
    add_index :db_sequences, :best_hmm_profile_id
  end

  def down
    remove_index :db_sequences, :best_hmm_profile_id
    remove_column :db_sequences, :best_hmm_profile_id
  end
end
