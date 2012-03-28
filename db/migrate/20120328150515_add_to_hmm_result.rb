class AddToHmmResult < ActiveRecord::Migration
  def up
    add_column :hmm_results, :hmm_profile_id, :integer
    add_index :hmm_results, :hmm_profile_id
  end
  
  def down
    remove_index :hmm_results, :hmm_profile_id
    remove_column :hmm_results, :hmm_profile_id
  end
end
