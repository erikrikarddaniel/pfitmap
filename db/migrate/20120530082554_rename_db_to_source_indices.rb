class RenameDbToSourceIndices < ActiveRecord::Migration
  def up
    remove_index :hmm_results, :sequence_db_id
    remove_column :hmm_results, :sequence_db_id
    add_column :hmm_results, :sequence_source_id, :integer, :null => false
    add_index :hmm_results, :sequence_source_id
  end
  def down
    remove_index :hmm_results, :sequence_db_source_id
    remove_column :hmm_results, :sequence_source_id
    add_column :hmm_results, :sequence_db_id, :integer, :null => false
    add_index :hmm_results, :sequence_db_id
  end
end
