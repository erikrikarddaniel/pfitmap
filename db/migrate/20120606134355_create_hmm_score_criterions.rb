class CreateHmmScoreCriterions < ActiveRecord::Migration
  def change
    create_table :hmm_score_criterions do |t|

      t.timestamps
    end
  end
end
