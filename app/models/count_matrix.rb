class CountMatrix
  include ActiveAttr::Model

  validates_presence_of :release

  attribute :release, :default => nil, :type => Float
  attribute :taxon_level, :default => "domain"
  attribute :protein_level, :default => "protclass"
  attribute :db, default: nil
  attribute :taxon_filter
  attribute :protein_filter

  attribute :taxons

  validate :release_exists

  def release_exists
    errors.add(:release, "does not exist") unless !PfitmapRelease.where("release='#{release}'").empty?
  end
end
