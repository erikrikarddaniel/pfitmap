class CreateResultRowSeqRel < ActiveRecord::Migration
  def change
    create_table :result_row_seq_rel do |t|
      t.integer :result_row_id
      t.integer :sequence_id
      
      t.timestamps
  end
    add_index :result_row_seq_rel, :result_row_id
    add_index :result_row_seq_rel, :sequence_id
    add_index :result_row_seq_rel, [:result_row_id, :sequence_id], unique: true
  end
end
