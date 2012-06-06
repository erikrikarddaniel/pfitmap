class CreateInclusionCriterions < ActiveRecord::Migration
  def change
    create_table :inclusion_criterions do |t|
      t.integer :hmm_profile_id

      t.timestamps
    end
    add_index :inclusion_criterions, :hmm_profile_id
  end
end
