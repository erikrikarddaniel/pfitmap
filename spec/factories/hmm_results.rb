FactoryGirl.define do
  factory :hmm_result do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile
    sequence_source
  end
  
  factory :hmm_result_nrda, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrda) }
    sequence_source
  end
  
  factory :hmm_result_nrdac, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdac) }
    sequence_source
  end
  
  factory :hmm_result_nrdae, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdae) }
    sequence_source
  end
  
  factory :hmm_result_nrdb, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdb) }
    sequence_source
  end
  
  factory :hmm_result_nrdben, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdben) }
    sequence_source
  end
  
  factory :hmm_result_nrdbe, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdbe) }
    sequence_source
  end
  
  factory :hmm_result_nrdbn, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdbn) }
    sequence_source
  end
  
  factory :hmm_result_nrdd, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdd) }
    sequence_source
  end
  
  factory :hmm_result_nrdda, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrdda) }
    sequence_source
  end
  
  factory :hmm_result_nrddb, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddb) }
    sequence_source
  end
  
  factory :hmm_result_nrddc, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddc) }
    sequence_source
  end
  
  factory :hmm_result_nrddc1, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddc1) }
    sequence_source
  end
  
  factory :hmm_result_nrddc2, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddc2) }
    sequence_source
  end
  
  factory :hmm_result_nrddd, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddd) }
    sequence_source
  end
  
  factory :hmm_result_nrddd1, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddd1) }
    sequence_source
  end
  
  factory :hmm_result_nrddd1a, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddd1a) }
    sequence_source
  end
  
  factory :hmm_result_nrddd2, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddd2) }
    sequence_source
  end
  
  factory :hmm_result_nrddd3, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddd3) }
    sequence_source
  end
  
  factory :hmm_result_nrddh, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddh) }
    sequence_source
  end
  
  factory :hmm_result_nrddh1, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddh1) }
    sequence_source
  end
  
  factory :hmm_result_nrddh2, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddh2) }
    sequence_source
  end
  
  factory :hmm_result_nrddh3, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddh3) }
    sequence_source
  end
  
  factory :hmm_result_nrddh4, class: HmmResult do
    sequence(:executed) { |n| "#{n}"}
    hmm_profile { |hmm_result| get_hmm_profile_named(:hmm_profile_nrddh4) }
    sequence_source
  end
end
