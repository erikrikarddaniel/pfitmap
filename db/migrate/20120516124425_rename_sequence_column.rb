class RenameSequenceColumn < ActiveRecord::Migration
  def up
    rename_column :db_sequences, :sequence, :aa_sequence
  end

  def down
    rename_column :db_sequences, :aa_sequence, :sequence
  end
end
