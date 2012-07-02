class AddCurrentToPfitmapRelease < ActiveRecord::Migration
  def change
    add_column :pfitmap_releases, :current, :boolean

  end
end
