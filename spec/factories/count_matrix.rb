FactoryGirl.define do
  factory :cmt0, class: CountMatrixTaxon do |cmt|
    ncbi_taxon_id	'ID'
    domain		'Bacteria'
    kingdom		'Bacteria no kingdom'
    phylum		'Phylum'
    taxclass		'Class'
    taxorder		'Order'
    taxfamily		'Family'
    genus		'Genus'
    species		'Genus species'
    strain		'Genus species strain n'
    no_genomes		2
  end

  factory :cmt1, class: CountMatrixTaxon do |cmt|
    ncbi_taxon_id	'ID'
    domain		'Bacteria'
    kingdom		'Bacteria no kingdom'
    phylum		'Phylum'
    taxclass		'Class'
    taxorder		'Order'
    taxfamily		'Family'
    genus		'Another_genus'
    species		'Another_genus species'
    strain		'Another_genus species strain n'
    no_genomes		1
  end

  factory :cmt0p0, class: CountMatrixTaxonProtein do |cmtp|
    protfamily			'PF'
    protclass			'PC'
    subclass			'PSC0'
    protgroup			'PG0'
    subgroup			'PSG0'
    subsubgroup			'PSSG0'
    no_proteins			3
    no_genomes_with_proteins	2
    all_accessions		'ACC1ACC2,ACC3,ACC4,ACC5'
    counted_accessions		'ACC1ACC2,ACC3'
  end

  factory :cmt0p1, class: CountMatrixTaxonProtein do |cmtp|
    protfamily			'PF'
    protclass			'PC'
    subclass			'PSC1'
    protgroup			'PG0'
    subgroup			'PSG0'
    subsubgroup			'PSSG0'
    no_proteins			3
    no_genomes_with_proteins	2
    all_accessions		'ACC1ACC2,ACC3,ACC4,ACC5'
    counted_accessions		'ACC1ACC2,ACC3'
  end

  factory :cmt1p1, class: CountMatrixTaxonProtein do |cmtp|
    protfamily			'PF'
    protclass			'PC'
    subclass			'PSC1'
    protgroup			'PG0'
    subgroup			'PSG0'
    subsubgroup			'PSSG0'
    no_proteins			1
    no_genomes_with_proteins	1
    all_accessions		'ACC1,ACC2'
    counted_accessions		'ACC1'
  end
end
