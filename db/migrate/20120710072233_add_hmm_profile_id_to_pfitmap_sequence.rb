class AddHmmProfileIdToPfitmapSequence < ActiveRecord::Migration
  def change
    add_column :pfitmap_sequences, :hmm_profile_id, :integer

  end
end
