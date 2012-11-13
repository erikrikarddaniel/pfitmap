# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  rank           :string(255)
#  hmm_profile_id :integer
#  enzyme_id      :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Protein < ActiveRecord::Base
  attr_accessible :name, :rank
  belongs_to :hmm_profile
  belongs_to :enzyme

  def self.initialize_proteins
    profiles = HmmProfile.all
    profiles.each do |profile|
      if profile.enzymes != []
        profile.enzymes.each do |enzyme|
          add_if_not_existing(enzyme,profile)
        end
      else
        add_if_not_existing(nil,profile)
      end
    end
  end

  def to_s
    "#{name} (#{rank})"
  end

  private
  def self.add_if_not_existing(enzyme, profile)
    if not find_by_belongs_to(enzyme,profile).first
      protein = new(name: profile.protein_name)
      protein.hmm_profile_id = profile.id
      if enzyme
        protein.enzyme_id = enzyme.id
      end
      protein.save
    end
  end
  
  def self.find_by_belongs_to(enzyme,profile)
    if enzyme
      where("hmm_profile_id = ? AND enzyme_id = ?", profile.id, enzyme.id)
    else
      where("hmm_profile_id = ?", profile.id)
    end
  end
end
