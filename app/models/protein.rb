# == Schema Information
#
# Table name: proteins
#
#  id             :integer         not null, primary key
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  protclass      :string(255)
#  subclass       :string(255)
#  group          :string(255)
#  subgroup       :string(255)
#  subsubgroup    :string(255)
#  protfamily     :string(255)
#  released_db_id :integer
#

class Protein < ActiveRecord::Base
  attr_accessible :protfamily, :protclass, :subclass, :group, :subgroup, :subsubgroup, :released_db_id
  belongs_to :hmm_profile
  belongs_to :released_db
  has_many :enzyme_proteins, dependent: :destroy
  has_many :enzymes, through: :enzyme_proteins, dependent: :destroy
  has_many :protein_counts, dependent: :destroy
  PROT_LEVELS = ["protfamily","protclass","subclass","group","subgroup","subsubgroup"]
  PROT_COLUMNS =  [:protfamily,:protclass,:subclass,:group,:subgroup,:subsubgroup]
  def self.initialize_proteins
    #Find all lowest level profiles. Each contains its hierarcy
    profiles = HmmProfile.all.select {|h| h.children==[]} 

    profiles.each do |profile|
      add_new_protein(profile)
    end
  end

  def to_s
    "#{protfamily}#{protclass}#{subclass}:#{group}:#{subgroup}:#{subsubgroup}"
  end

  private
  def self.add_new_protein(profile)
    #Create a new protein based on the hierarchy of the profile.
    #nil is added to levels where there is no hierarchy.
    #Then add all the enzymes found in profiles in the hierarchy
    protein = find_by_belongs_to(profile).first
    if not protein
      protein = new()
      protein.hmm_profile_id = profile.id
    end
    PROT_LEVELS.zip(profile.hierarchy.split(':')).map {|k,j| protein[k] = j}
    protein.save
    add_enzymes_protein(protein,profile)
  end

  def self.add_enzymes_protein(protein,profile)
    #For the given protein and profile, add enzyme_protein relation if enzymes exist
    #If profile has parent profiles, add those enzymes as well
    profile.enzymes.each do |e|
      EnzymeProtein.find_or_create_by_enzyme_id_and_protein_id(e.id, protein.id)
    end
    if profile.parent_id
      add_enzymes_protein(protein,HmmProfile.find(profile.parent_id))
    end
  end

  def self.add_if_not_existing(enzymes, profile)
    protein =  find_by_belongs_to(profile).first
    if not protein
      protein = new()
      protein.hmm_profile_id = profile.id
    end
    # Update eventual changes in protein_name
    PROT_LEVELS.zip(profile.hierarchy.split(':')).map {|k,j| protein[k] = j}
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
