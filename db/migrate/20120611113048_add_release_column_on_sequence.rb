class AddReleaseColumnOnSequence < ActiveRecord::Migration
  def change
    add_column :pfitmap_sequences, :pfitmap_release_id, :integer
    add_index :pfitmap_sequences, :pfitmap_release_id
  end
end
