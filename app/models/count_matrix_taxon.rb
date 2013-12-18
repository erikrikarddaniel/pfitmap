class CountMatrixTaxon
  include ActiveAttr::Model

  attribute :ncbi_taxon_id
  attribute :domain 
  attribute :kingdom
  attribute :phylum
  attribute :taxclass
  attribute :taxorder
  attribute :taxfamily
  attribute :genus
  attribute :species
  attribute :strain
  attribute :no_genomes
  attribute :all_accessions
  attribute :counted_accessions

  attribute :proteins, :default=>[]
  def hierarchy
    "#{domain}:#{kingdom}:#{phylum}:#{taxclass}:#{taxorder}:#{taxfamily}:#{genus}:#{species}:#{strain}"
  end

end
