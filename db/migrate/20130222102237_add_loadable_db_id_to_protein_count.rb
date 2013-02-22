class AddLoadableDbIdToProteinCount < ActiveRecord::Migration
  def change
    add_column :protein_counts, :loadable_db_id, :integer
  end
end
