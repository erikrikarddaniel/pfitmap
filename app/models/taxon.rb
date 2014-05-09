# == Schema Information
#
# Table name: taxons
#
#  id             :integer         not null, primary key
#  ncbi_taxon_id  :integer
#  wgs            :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  domain         :string(255)
#  kingdom        :string(255)
#  phylum         :string(255)
#  taxclass       :string(255)
#  taxorder       :string(255)
#  taxfamily      :string(255)
#  genus          :string(255)
#  species        :string(255)
#  strain         :string(255)
#  released_db_id :integer
#  no_genomes     :integer
#

class Taxon < ActiveRecord::Base
  # The hierarchy association uses ncbi_ids to make it easier to construct from retrieved data
  attr_accessible :domain, :kingdom, :phylum, :taxclass, :taxorder, :taxfamily, :genus, :species, :strain, :released_db_id, :ncbi_taxon_id
  has_many :protein_counts, dependent: :destroy
  belongs_to :released_db

  RANKS = ["superkingdom", "kingdom", "phylum", "class", "order", "family", "genus", "species"]
  TAXA =  ["domain", "kingdom", "phylum", "taxclass", "taxorder", "taxfamily", "genus", "species", "strain"]
  TAXA_PROPER_NAMES = {"domain"=>"Domain", "kingdom"=>"Kingdom", "phylum"=>"Phylum", "taxclass"=>"Class", "taxorder"=>"Order", "taxfamily"=>"Family", "genus"=>"Genus", "species"=>"Species","strain"=>"Strain"}

  def to_s
    "Taxon: #{domain}:#{kingdom}:#{phylum}:#{taxclass}:#{taxorder}:#{taxfamily}:#{genus}:#{species}:#{strain}"
  end
end
