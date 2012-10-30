FactoryGirl.define do
  factory :hmm_result do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile
    sequence_source
  end
  
  factory :hmm_result_nrdb, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdb) }
#    association :hmm_profile, factory: :hmm_profile_nrdb
    sequence_source
  end
  
  factory :hmm_result_nrdben, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdben) }
#   association :hmm_profile, factory: :hmm_profile_nrdben
    sequence_source
  end
  
  factory :hmm_result_nrdbe, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdbe) }
#   association :hmm_profile, factory: :hmm_profile_nrdbe
    sequence_source
  end
  
  factory :hmm_result_nrdbn, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdbn) }
#    association :hmm_profile, factory: :hmm_profile_nrdbn
    sequence_source
  end
end
