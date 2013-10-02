class AddReleaseIdToTaxon < ActiveRecord::Migration
  def change
    add_column :taxons, :pfitmap_release_id, :integer 
  end
end
