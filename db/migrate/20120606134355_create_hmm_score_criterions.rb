class CreateHmmScoreCriterions < ActiveRecord::Migration
  def change
    create_table :hmm_score_criterions do |t|
      t.float :min_fullseq_score
      t.integer :inclusion_criterion_id
      
      t.timestamps
    end
  end
end
