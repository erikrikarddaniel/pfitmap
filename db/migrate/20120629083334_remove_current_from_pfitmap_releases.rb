class RemoveCurrentFromPfitmapReleases < ActiveRecord::Migration
  def up
    remove_column :pfitmap_releases, :current
  end

  def down
    add_column :pfitmap_releases, :current, :boolean
  end
end
