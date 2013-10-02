class CountMatrixTaxonProtein
  include ActiveAttr::Model

  attribute :protclass
  attribute :subclass
  attribute :group
  attribute :subgroup
  attribute :subsubgroup
  attribute :n_proteins
  attribute :n_genomes_with_proteins

end
