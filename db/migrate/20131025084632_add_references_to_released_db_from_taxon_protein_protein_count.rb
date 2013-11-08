class AddReferencesToReleasedDbFromTaxonProteinProteinCount < ActiveRecord::Migration
  def change
    change_table :protein_counts do |pc|
      pc.remove :pfitmap_release_id
      pc.remove :obs_as_genome
      pc.references :released_db
    end
    change_table :taxons do |t|
      t.remove :pfitmap_release_id
      t.references :released_db
    end
    change_table :proteins do |p|
      p.remove :hmm_profile_id
      p.references :released_db
    end
  end
end
