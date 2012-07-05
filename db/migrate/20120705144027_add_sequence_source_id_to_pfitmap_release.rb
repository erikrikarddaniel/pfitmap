class AddSequenceSourceIdToPfitmapRelease < ActiveRecord::Migration
  def change
    add_column :pfitmap_releases, :sequence_source_id, :integer

  end
end
