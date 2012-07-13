# == Schema Information
#
# Table name: pfitmap_sequences
#
#  id                 :integer         not null, primary key
#  db_sequence_id     :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  pfitmap_release_id :integer
#  hmm_profile_id     :integer
#

class PfitmapSequence < ActiveRecord::Base
  attr_accessible :db_sequence_id, :pfitmap_release_id, :hmm_profile_id
  belongs_to :db_sequence
  belongs_to :pfitmap_release
  belongs_to :hmm_profile
  has_many :hmm_db_hits, :through => :db_sequence
  has_one :sequence_source, :through => :pfitmap_release

  # calculate_counts(pr : pfitmap_release)
  def calculate_counts(pr)
    ref_hits = self.db_hits_from_ref
    best_profile = self.hmm_profile
    profiles = best_profile.all_parents_including_self
    ref_hits.each do |ref_hit|
      profiles.each do |profile|
        if profile.enzymes != []
          profile.enzymes.each do |enzyme|
            protein = Protein.add_if_not_existing(enzyme,profile)
            Taxon.add_all_if_not_existing(ref_hit.all_gold_taxons)
            ProteinCount.add_to_count(protein, ref_hit.all_gold_taxons, pr)
          end
        else
          protein = Protein.add_if_not_existing(nil,profile)
          ProteinCount.add_to_count(protein, ref_hit.all_gold_taxons, pr)
        end
      end
    end
  end

  def db_hits_from_ref
    self.hmm_db_hits.where("db = 'ref'")
  end
end
