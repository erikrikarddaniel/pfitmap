class AddSequenceSourceIdToPfitmapRelease < ActiveRecord::Migration
  def change
    add_column :pfitmap_releases, :sequence_source, :references

  end
end
