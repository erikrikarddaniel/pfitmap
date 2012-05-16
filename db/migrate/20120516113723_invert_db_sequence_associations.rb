class InvertDbSequenceAssociations < ActiveRecord::Migration
  def up
    remove_index :db_sequences, :hmm_result_row_id
    remove_index :db_sequences, :hmm_db_hit_id
    remove_column :db_sequences, :hmm_result_row_id
    remove_column :db_sequences, :hmm_db_hit_id
    add_column :hmm_result_rows, :db_sequence_id, :integer
    add_column :hmm_db_hits, :db_sequence_id, :integer
    add_index :hmm_result_rows, :db_sequence_id
    add_index :hmm_db_hits, :db_sequence_id
  end

  def down
    remove_index :hmm_result_rows, :db_sequence_id
    remove_index :hmm_db_hits, :db_sequence_id
    remove_column :hmm_result_rows, :db_sequence_id, :integer
    remove_column :hmm_db_hits, :db_sequence_id, :integer
    add_column :db_sequences, :hmm_result_row_id
    add_column :db_sequences, :hmm_db_hit_id
    add_index :db_sequences, :hmm_result_row_id
    add_index :db_sequences, :hmm_db_hit_id
  end
end
