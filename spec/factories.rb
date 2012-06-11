FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name){ |n| "Example Class #{n}" }
    sequence(:hierarchy) { |n| "00#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :hmm_profile_001, class: HmmProfile do
    name "RNR R2 and R2lox"
    hierarchy "001"
    version "20120401"
  end
  
  factory :hmm_profile_00100, class: HmmProfile do
    name "RNR R2"
    hierarchy "001.00"
    version "20120401"
    association :parent, factory: :hmm_profile_001
  end

  factory :hmm_profile_001_with_children, class: HmmProfile do |p|
    p.name "RNR R2 and R2lox"
    p.hierarchy "001"
    p.version "20120401"
  end
  
  factory :hmm_profile_00101, class: HmmProfile do
    name "R2lox"
    hierarchy "001.01"
    version "20120401"
    association :parent, factory: :hmm_profile_001
  end
  
  factory :hmm_profile_000, class: HmmProfile do
    name "RNR R1 and PFL"
    hierarchy "000"
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
  end

  factory :inclusion_criterion do
    hmm_profile
  end

  factory :hmm_score_criterion do
    hmm_profile
    min_fullseq_score 15.0
  end

  factory :pfitmap_release do
  end
end
