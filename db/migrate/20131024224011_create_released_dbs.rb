class CreateReleasedDbs < ActiveRecord::Migration
  def change
    create_table :released_dbs do |t|
      t.references :pfitmap_release
      t.references :load_database

      t.timestamps
    end
    add_index :released_dbs, :pfitmap_release_id
    add_index :released_dbs, :load_database_id
  end
end
