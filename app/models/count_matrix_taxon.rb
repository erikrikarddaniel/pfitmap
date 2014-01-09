class CountMatrixTaxon < ActiveRecord::Base
  has_no_table

  column :count_matrix_id,	:integer
  column :ncbi_taxon_id,	:string
  column :domain,		:string
  column :kingdom,		:string
  column :phylum,		:string
  column :taxclass,		:string
  column :taxorder,		:string
  column :taxfamily,		:string
  column :genus,		:string
  column :species,		:string
  column :strain,		:string
  column :no_genomes,		:string

  attr_accessible :ncbi_taxon_id, :domain, :kingdom, :phylum, :taxclass,
    :taxorder, :taxfamily, :genus, :species, :strain, :no_genomes

  def add_protein(p)
    @proteins ||= { }
    @proteins[p.hierarchy] = p
  end

  def hierarchy
    "#{domain}:#{kingdom}:#{phylum}:#{taxclass}:#{taxorder}:#{taxfamily}:#{genus}:#{species}:#{strain}"
  end
  
  def proteins
    @proteins ? @proteins.values.sort_by { |p| p.hierarchy } : []
  end

  def to_json(indent = "", indlevel = 0)
    <<-JSON
#{ indent * indlevel }{"ncbi_taxon_id":#{ncbi_taxon_id},"domain":"#{domain}","kingdom":"#{kingdom}","phylum":"#{phylum}","taxclass":"#{taxclass}","taxorder":"#{taxorder}","taxfamily":"#{taxfamily}","genus":"#{genus}","species":"#{species}","strain":"#{strain}","proteins":[ ]}
    JSON
  end

  def to_s
    "CountMatrixTaxon #{hierarchy}, no_genomes: #{no_genomes}, proteins: (#{@proteins ? @proteins.values.join("),(") : ''})"
  end
end
