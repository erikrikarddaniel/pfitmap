class CreatePfitmapReleases < ActiveRecord::Migration
  def change
    create_table :pfitmap_releases do |t|
      t.string :release
      t.date :release_date
      t.boolean :current
      
      t.timestamps
    end
    add_index :pfitmap_releases, :current
  end
end
