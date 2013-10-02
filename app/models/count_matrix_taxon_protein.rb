class CountMatrixTaxonProtein
  include ActiveAttr::Model

  attribute :protclass
  attribute :subclass
  attribute :group
  attribute :subgroup
  attribute :subsubgroup
  attribute :no_proteins
  attribute :no_genomes_with_proteins

end
