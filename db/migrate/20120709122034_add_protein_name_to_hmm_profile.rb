class AddProteinNameToHmmProfile < ActiveRecord::Migration
  def change
    add_column :hmm_profiles, :protein_name, :string

  end
end
