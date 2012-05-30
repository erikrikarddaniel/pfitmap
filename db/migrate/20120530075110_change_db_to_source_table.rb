class ChangeDbToSourceTable < ActiveRecord::Migration
  def change
    rename_table :sequence_dbs, :sequence_sources
  end

  def up
    
  end
end
