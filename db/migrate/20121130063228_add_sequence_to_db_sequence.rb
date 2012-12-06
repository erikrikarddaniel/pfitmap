class AddSequenceToDbSequence < ActiveRecord::Migration
  def change
    add_column :db_sequences, :sequence, :text
  end
end
