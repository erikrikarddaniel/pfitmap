class AddRankToHmmProfiles < ActiveRecord::Migration
  def change
    add_column :hmm_profiles, :rank, :string
  end
end
