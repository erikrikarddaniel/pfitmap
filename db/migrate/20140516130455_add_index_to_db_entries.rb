class AddIndexToDbEntries < ActiveRecord::Migration
  def change
    DbEntry.connection.execute('DROP INDEX IF EXISTS index_db_entries_on_gi')
    add_index :db_entries, :gi, :unique => true
  end
end
