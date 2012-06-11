class AddReleaseColumnOnSequence < ActiveRecord::Migration
  def change
    add_column :pfitmap_sequences, :pfitmap_release_id, :integer
  end
end
