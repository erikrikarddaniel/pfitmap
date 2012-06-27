class ChangeNameForHmmScoreCriterions < ActiveRecord::Migration
  def change
    rename_table :hmm_score_criterions, :hmm_score_criteria
  end
end
