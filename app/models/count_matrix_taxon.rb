class CountMatrixTaxon
  include ActiveAttr::Model

  attribute :ncbi_taxon_id
  attribute :domain 
  attribute :kingdom
  attribute :phylum
  attribute :taxclass
  attribute :taxorder
  attribute :family
  attribute :genus
  attribute :species
  attribute :strain
  attribute :no_genomes

  attribute :proteins, :default=>[]
  def hierarchy
    "#{domain}:#{kingdom}:#{phylum}:#{taxclass}:#{taxorder}:#{family}:#{genus}:#{species}:#{strain}"
  end

end
