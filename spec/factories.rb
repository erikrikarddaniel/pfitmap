FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name) { |n| "#{n}"}
    sequence(:hierarchy) { |n| "00#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :sequence_db do
    source "NCBI"
    name "ref"
    version "20120328"
  end
    
  
  factory :hmm_result do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile
    sequence_db
  end

  factory :resultRow do
    result
  end
  
  factory :sequence do
    sequence(:seq) { |n| "#{n}" }
  end
  
  factory :resultRowsSequence do
    resultRow
#    sequence
  end
end
