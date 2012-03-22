class DropAndRecreateRelationTable < ActiveRecord::Migration
  def change
    drop_table :result_row_seq_rel
    create_table :result_rows_sequences do |t|
      t.column "result_row_id", :integer, :null => false
      t.column "sequence_id", :integer, :null => false
      
      t.timestamps
    end
    add_index :result_rows_sequences, :result_row_id
    add_index :result_rows_sequences, :sequence_id
    add_index :result_rows_sequences, [:result_row_id, :sequence_id], unique: true
  end

  def down
  end
end
