class RemoveAaSequenceAttribute < ActiveRecord::Migration
  def up
    remove_column :db_sequences, :aa_sequence
  end

  def down
    add_column :db_sequences, :aa_sequence, :text
  end
end
