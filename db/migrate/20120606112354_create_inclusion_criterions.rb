class CreateInclusionCriterions < ActiveRecord::Migration
  def change
    create_table :inclusion_criterions do |t|
      t.integer :hmm_profile_id
      t.float :min_fullseq_score
      t.string :type

      t.timestamps
    end
    add_index :inclusion_criterions, [:hmm_profile_id, :type]
  end
end
