class CountMatrixTaxonProtein
  include ActiveAttr::Model
  attribute :protfamily
  attribute :protclass
  attribute :subclass
  attribute :protgroup
  attribute :subgroup
  attribute :subsubgroup
  attribute :no_proteins
  attribute :no_genomes_with_proteins
  attribute :all_accessions
  attribute :counted_accessions
end
