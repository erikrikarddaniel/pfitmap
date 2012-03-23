FactoryGirl.define do
  factory :profile do
    sequence(:name) { |n| "#{n}"}
    parent_profile_id  ""
  end
  
  factory :result do
    sequence(:date) { |n| "#{n}"}
    profile
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
