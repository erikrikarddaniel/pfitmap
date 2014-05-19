class AddConstraintDbSequenceIdNotNullToDbEntry < ActiveRecord::Migration
  def change
    change_column :db_entries, :db_sequence_id, :integer, :null => false
  end
end
