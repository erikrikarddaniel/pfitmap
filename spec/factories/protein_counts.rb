FactoryGirl.define do
  factory :taxon do |t|
    sequence(:domain) { |n|  "example_domain_name " + n.to_s }
    sequence(:ncbi_taxon_id) { |n| n} 
  end

  factory :taxon_flat, class: Taxon do |t|
    sequence(:ncbi_taxon_id) {|n| n}
  end

  factory :taxon_bacteria, class: Taxon do
    domain	'Bacteria'
  end

  factory :taxon_proteobacteria, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
  end

  factory :taxon_gammaproteobacteria, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
  end

  factory :taxon_enterobacteriales, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
  end

  factory :taxon_enterobacteriaceae, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
  end

  factory :taxon_escherichia, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
    genus	'Escherichia'
  end

  factory :taxon_escherichia_coli, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
    genus	'Escherichia'
    species	'Escherichia coli'
  end

  factory :taxon_escherichia_coli_k12, class: Taxon do
    domain	'Bacteria'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
    genus	'Escherichia'
    species	'Escherichia coli'
    strain	'Escherichia coli K-12'
  end

  factory :protein do
    sequence(:protfamily) { |n| "ex_protein " + n.to_s }
  end

  factory :protein_count do
    no_proteins 0
    no_genomes_with_proteins 0
    protein
    taxon
    released_db
  end

  factory :sequence_database do
    db "ref"
    abbreviation "refseq"
    home_page "home"
    accession_url "url"
  end

  factory :load_database do
    taxonset "http://demo.url/test.json"
    name "ref + wgs"
    description "refseq and wholegenomesequenced"
    active true
  end

  factory :released_db do
    load_database
    pfitmap_release
  end

  factory :e_coli_c227_11_nrdag_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_e_coli_c227_11
    association :protein, factory: :protein_nrdag
    no_proteins		1
    counted_accessions	'EGT66349.1'
    all_accessions	'EGT66349.1,EHF27785.1'
  end

  factory :e_coli_c227_11_nrde_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_e_coli_c227_11
    association :protein, factory: :protein_nrde
    no_proteins		2
    counted_accessions	'EGT69637.1,EHF28204.1'
    all_accessions	'EGT69637.1,EHF28204.1'
  end

  factory :e_coli_c227_11_nrddc_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_e_coli_c227_11
    association :protein, factory: :protein_nrddc
    no_proteins		1
    counted_accessions	'EGT67559.1'
    all_accessions	'EGT67559.1,EHF19970.1'
  end

  factory :e_coli_c227_11_nrdbg_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_e_coli_c227_11
    association :protein, factory: :protein_nrdbg
    no_proteins		1
    counted_accessions	'EGT66348.1'
    all_accessions	'EGT66348.1,EHF27786.1'
  end

  factory :e_coli_c227_11_nrdf_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_e_coli_c227_11
    association :protein, factory: :protein_nrdf
    no_proteins		1
    counted_accessions	'EGT69638.1'
    all_accessions	'EGT69638.1,EHF28205.1'
  end

  factory :y_pestis_medievalis_nrdag_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_y_pestis_medievalis
    association :protein, factory: :protein_nrdag
    no_proteins		1
    counted_accessions	'ADV99515.1'
    all_accessions	'ADV99515.1'
  end

  factory :y_pestis_medievalis_nrde_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_y_pestis_medievalis
    association :protein, factory: :protein_nrde
    no_proteins		2
    counted_accessions	'ADV99712.1'
    all_accessions	'ADV99712.1'
  end

  factory :y_pestis_medievalis_nrddc_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_y_pestis_medievalis
    association :protein, factory: :protein_nrddc
    no_proteins		1
    counted_accessions	'ADW00229.1'
    all_accessions	'ADW00229.1'
  end

  factory :y_pestis_medievalis_nrdbg_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_y_pestis_medievalis
    association :protein, factory: :protein_nrdbg
    no_proteins		1
    counted_accessions	'ADV99516.1'
    all_accessions	'ADV99516.1'
  end

  factory :y_pestis_medievalis_nrdf_protein_count, class: ProteinCount do |pc|
    association :taxon, factory: :taxon_y_pestis_medievalis
    association :protein, factory: :protein_nrdf
    no_proteins		1
    counted_accessions	'ADV99713.1'
    all_accessions	'ADV99713.1'
  end

  factory :protein_nrdag, class: Protein do |pc|
    protfamily	'Nrd-PFL'
    protclass	'NrdA'
    subclass	'NrdAg'
  end

  factory :protein_nrde, class: Protein do |pc|
    protfamily	'Nrd-PFL'
    protclass	'NrdA'
    subclass	'NrdE'
  end

  factory :protein_nrddc, class: Protein do |pc|
    protfamily	'Nrd-PFL'
    protclass	'NrdD'
    subclass	'NrdDc'
  end

  factory :protein_nrdbg, class: Protein do |pc|
    protfamily	'NrdB-R2lox'
    protclass	'NrdB'
    subclass	'NrdBg'
  end

  factory :protein_nrdf, class: Protein do |pc|
    protfamily	'NrdB-R2lox'
    protclass	'NrdB'
    subclass	'NrdF'
  end

  factory :taxon_e_coli_c227_11, class: Taxon do |t|
    domain	'Bacteria'
    kingdom	'Bacteria, no kingdom'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
    genus	'Escherichia'
    species	'Escherichia coli'
    strain	'Escherichia coli  O104:H4 str. C227-11'
  end

  factory :taxon_y_pestis_medievalis, class: Taxon do |t|
    domain	'Bacteria'
    kingdom	'Bacteria, no kingdom'
    phylum	'Proteobacteria'
    taxclass	'Gammaproteobacteria'
    taxorder	'Enterobacteriales'
    taxfamily	'Enterobacteriaceae'
    genus	'Yersinia'
    species	'Yersinia pestis'
    strain	'Yersinia pestis biovar Medievalis str. Harbin 35'
  end
end
