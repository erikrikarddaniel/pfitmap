class CreateSequenceDb < ActiveRecord::Migration
  def up
    rename_table :hmm_result_rows_hmm_db_hits, :db_sequences
    add_column :db_sequences, :sequence, :text
  end

  def down
    remove_column :db_sequences, :sequence
    rename_table :db_sequences, :hmm_result_rows_hmm_db_hits
  end
end
