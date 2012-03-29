class CreateHmmResultRows < ActiveRecord::Migration
  def change
    create_table :hmm_result_rows do |t|
      t.string :target_name
      t.string :target_acc
      t.string :query_name
      t.string :query_acc
      t.float :fullseq_evalue
      t.float :fullseq_score
      t.float :fullseq_bias
      t.float :bestdom_evalue
      t.float :bestdom_score
      t.float :bestdom_bias
      t.float :domnumest_exp
      t.integer :domnumest_reg
      t.integer :domnumest_clu
      t.integer :domnumest_ov
      t.integer :domnumest_env
      t.integer :domnumest_rep
      t.integer :domnumest_inc

      t.timestamps
    end
  end
end
