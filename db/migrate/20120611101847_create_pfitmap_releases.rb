class CreatePfitmapReleases < ActiveRecord::Migration
  def change
    create_table :pfitmap_releases do |t|

      t.timestamps
    end
  end
end
