class CreateEnzymeProfiles < ActiveRecord::Migration
  def change
    create_table :enzyme_profiles do |t|
      t.references :hmm_profile
      t.references :enzyme

      t.timestamps
    end
    add_index :enzyme_profiles, :hmm_profile_id
    add_index :enzyme_profiles, :enzyme_id
  end
end
