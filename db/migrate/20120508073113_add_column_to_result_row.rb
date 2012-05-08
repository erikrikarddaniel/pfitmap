class AddColumnToResultRow < ActiveRecord::Migration
  def up
    add_column :hmm_result_rows, :domnumest_dom, :integer
  end
  def down
    remove_column :hmm_result_rows, :domnumest_dom
  end
end
