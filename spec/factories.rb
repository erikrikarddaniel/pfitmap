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
  
  factory :sequence_db do
    source "NCBI"
    name "ref"
    version "20120328"
  end
  
  factory :sequence_db_older, class: SequenceDb do
    source "NCBI"
    name "ref"
    version "20120128"
  end
  
  factory :hmm_result do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile
    sequence_db
  end
  
  factory :hmm_db_hit do
    sequence(:gi){|n| n}
    db "ref"
    sequence(:acc) { |n| "aaaa#{n}" }
    desc "This is an example hit"
  end
  
  factory :hmm_result_row do
    hmm_result
    target_name "gi|160942848|ref|ZP_02090088.1|"
    fullseq_evalue 3e-300
  end
  
  factory :hmm_result_row2 do
    hmm_result
    target_name "gi|167748341|ref|ZP_02420468.1|"
    fullseq_evalue 4e-100
  end
end
