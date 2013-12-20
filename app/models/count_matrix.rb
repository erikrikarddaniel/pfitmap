class CountMatrix < ActiveRecord::Base
  has_no_table

  column :release, :string, :default => nil
  column :taxon_level, :string, :default => "domain"
  column :protein_level, :string, :default => "protclass"
  column :db, :string, default: nil
  column :taxon_filter, :string
  column :protein_filter, :string

  attr_accessible :release, :taxon_level, :protein_level, :db, :taxon_filter, :protein_filter

  validates_presence_of :release
  validate :release_exists

  def add_taxon(t)
    @taxons ||= { }
    @taxons[t.hierarchy] = t
  end

  def sort!
    @sorted_taxons = @taxons.values.sort_by { |t| t.hierarchy }
  end

  def taxon(t)
    @taxons[t.hierarchy]
  end

  def taxons
    self.sort! unless @sorted_taxons
    @sorted_taxons
  end

  def release_exists
    errors.add(:release, "does not exist") unless !PfitmapRelease.where("release='#{release}'").empty?
  end
end
