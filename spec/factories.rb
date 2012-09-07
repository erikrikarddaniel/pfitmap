FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name){ |n| "Example Class #{n}" }
    sequence(:protein_name) { |n| "NrdX#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :hmm_profile_nrdbr2lox, class: HmmProfile do
    name "RNR R2 and R2lox"
    protein_name "NrdB:R2lox"
    version "20120401"
  end
  
  factory :hmm_profile_nrdb, class: HmmProfile do
    name "Class I RNR radical generating subunit"
    protein_name "NrdB"
    version "20120401"
    association :parent, factory: :hmm_profile_nrdbr2lox
  end
  
  factory :hmm_profile_nrdben, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes and sister group"
    protein_name "NrdBen"
    version "20120401"
    association :parent, factory: :hmm_profile_nrdb
  end
  
  factory :hmm_profile_nrdbe, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes"
    protein_name "NrdBe"
    version "20120401"
    association :parent, factory: :hmm_profile_nrdben
  end
  
  factory :hmm_profile_nrdbn, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotic sister-group"
    protein_name "NrdBn"
    version "20120401"
    association :parent, factory: :hmm_profile_nrdben
  end
  
  factory :hmm_profile_r2lox, class: HmmProfile do
    name "R2lox protein"
    protein_name "R2lox"
    version "20120401"
    association :parent, factory: :hmm_profile_nrdbr2lox
  end
  
  factory :hmm_profile_nrdapfl, class: HmmProfile do
    name "RNR R1 and PFL"
    protein_name "NrdA:PFL"
    version "20120401"
  end
  
  factory :sequence_source do
    source "NCBI"
    name "NR"
    version "20120328"
  end
  
  factory :sequence_source_older, class: SequenceSource do
    source "NCBI"
    name "NR"
    version "20120128"
  end

  factory :db_sequence do
  end
  
  factory :hmm_result do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile
    sequence_source
  end
  
  factory :hmm_db_hit do
    sequence(:gi){|n| n}
    db "ref"
    desc "This is an example hit"
    db_sequence
  end

  factory :hmm_db_hit_pdb, class: HmmDbHit do
    gi '13'
    db 'pdb'
    acc '1mxl'
    desc 'An example PDB hit'
    db_sequence
  end
  
  factory :hmm_result_row, class: HmmResultRow do
    hmm_result
    target_name "gi|160942848|ref|ZP_02090088.1|"
    fullseq_evalue 3e-300
    fullseq_score 50.0
    db_sequence
  end
  
  factory :hmm_result_row2, class: HmmResultRow do
    hmm_result
    target_name "gi|167748341|ref|ZP_02420468.1|"
    fullseq_evalue 4e-100
    fullseq_score 10.0
    db_sequence
  end

  factory :pfitmap_sequence do
    db_sequence
    pfitmap_release
    hmm_profile
  end

  factory :hmm_score_criterion do
    hmm_profile
    min_fullseq_score 15.0
  end

  factory :pfitmap_release do
    sequence(:release) { |n|  (0.0 + 0.1*n).to_s }
    sequence(:release_date) { |n| (Date.new(2012,01,01) + n.days).to_s }
    current "false"
    sequence_source
  end

  factory :user do
    provider "open_id"
    uid "ex123456"
    name "johannes"
    email "jorasaatte@gmail.com"
    role "guest"
  end

  factory :user_admin, class: User do
    provider "open_id"
    uid "ex1236"
    name "Bob"
    email "bob@example.com"
    role "admin"
  end 

  factory :enzyme do
    name "Example ENZ"
  end

  factory :enzyme_profile do
    enzyme
    hmm_profile
  end

  factory :taxon do
    sequence(:name) { |n|  "example_taxon_name " + n.to_s }
    sequence(:ncbi_taxon_id) { |n| n} 
  end

  factory :protein do
    sequence(:name) { |n| "ex_protein " + n.to_s }
    hmm_profile
    enzyme
 end

  factory :protein_count do
    no_genomes 0
    no_proteins 0
    no_genomes_with_proteins 0
    protein
    pfitmap_release
    taxon
  end

end
