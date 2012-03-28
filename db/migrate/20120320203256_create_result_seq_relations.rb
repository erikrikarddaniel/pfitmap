class CreateResultSeqRelations < ActiveRecord::Migration
  def change
    create_table :result_seq_relations do |t|
      t.integer :result_id
      t.integer :sequence_id

      t.timestamps
    end
    add_index :result_seq_relations, :result_id
    add_index :result_seq_relations, :sequence_id
    add_index :result_seq_relations, [:result_id, :sequence_id], unique: true
  end
end
