class CountMatrixTaxonProtein < ActiveRecord::Base
  has_no_table

  column :protfamily,			:string
  column :protclass,			:string
  column :subclass,			:string
  column :protgroup,			:string
  column :subgroup,			:string
  column :subsubgroup,			:string
  column :no_proteins,			:integer
  column :no_genomes_with_proteins,	:integer
  column :all_accessions,		:string
  column :counted_accessions,		:string

  attr_accessible :protfamily, :protclass, :subclass, :protgroup, :subgroup, 
    :subsubgroup, :no_proteins, :no_genomes_with_proteins, :all_accessions, 
    :counted_accessions

  def hierarchy
    "#{protfamily}:#{protclass}:#{subclass}:#{protgroup}:#{subgroup}:#{subsubgroup}"
  end

  def to_s
    "<CountMatrixTaxonProtein #{hierarchy} #{no_genomes_with_proteins} #{no_proteins}>"
  end
end
