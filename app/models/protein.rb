# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Protein < ActiveRecord::Base
  attr_accessible :name, :rank
  belongs_to :hmm_profile
  has_many :enzyme_proteins, dependent: :destroy
  has_many :enzymes, through: :enzyme_proteins, dependent: :destroy
  has_many :protein_counts, dependent: :destroy

  def self.initialize_proteins
    profiles = HmmProfile.all
    profiles.each do |profile|
      if profile.enzymes != []
        enzymes = profile.enzymes
        add_if_not_existing(enzymes,profile)
      else
        add_if_not_existing(nil,profile)
      end
    end
  end

  def to_s
    "#{name} (#{rank})"
  end

  private
  def self.add_if_not_existing(enzymes, profile)
    protein =  find_by_belongs_to(profile).first
    if not protein
      protein = new()
      protein.hmm_profile_id = profile.id
    end
    # Update eventual changes in protein_name
    protein.name = profile.protein_name
    protein.save
    
    if enzymes
      enzymes.each do |e|
        EnzymeProtein.find_or_create_by_enzyme_id_and_protein_id(e.id, protein.id)
      end
    end
  end
  
  def self.find_by_belongs_to(profile)
    where("hmm_profile_id = ?", profile.id)
  end
end
