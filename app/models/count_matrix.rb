class CountMatrix
  include ActiveAttr::Model

  validates_presence_of :release

  attribute :release, :default => nil, :type => Float
  attribute :taxon_names, :default => []
  attribute :protein_names, :default => []

  validate :release_exists

  def release_exists
    errors.add(:release, "does not exist") unless !PfitmapRelease.where("release='#{release}'").empty?
  end
end
