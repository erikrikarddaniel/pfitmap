class AddForeignKeysToHmmResultsRow < ActiveRecord::Migration
  def change
    add_column :hmm_result_rows, :hmm_result_id, :integer
  end
end
