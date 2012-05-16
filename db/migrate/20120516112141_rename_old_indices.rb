class RenameOldIndices < ActiveRecord::Migration
  def up
    remove_index(:db_sequences, :name => :index_hmm_result_rows_hmm_db_hits_on_hmm_db_hit_id)
    add_index :db_sequences, :hmm_db_hit_id
    remove_index(:db_sequences, :name => :index_hmm_result_rows_hmm_db_hits_on_hmm_result_row_id)
    add_index :db_sequences, :hmm_result_row_id
  end

  def down
    remove_index :db_sequences, :hmm_result_row_id
    add_index :db_sequences, :name => :index_hmm_result_rows_hmm_db_hits_on_hmm_result_row_id
    remove_index :db_sequences, :hmm_db_hit_id
    add_index :db_sequences, :name => :index_hmm_result_rows_hmm_db_hits_on_hmm_db_hit_id
  end
end
