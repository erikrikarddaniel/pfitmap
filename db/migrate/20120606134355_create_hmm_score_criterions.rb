class CreateHmmScoreCriterions < ActiveRecord::Migration
  def change
    create_table :hmm_score_criterions do |t|
      t.float :min_fullseq_score
      t.integer :hmm_profile_id
      
      t.timestamps
    end
    add_index :hmm_score_criterions, :hmm_profile_id
  end
end
