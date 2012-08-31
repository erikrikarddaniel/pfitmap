class AddHmmLogoToHmmProfile < ActiveRecord::Migration
  def change
    add_column :hmm_profiles, :hmm_logo, :string
  end
end
