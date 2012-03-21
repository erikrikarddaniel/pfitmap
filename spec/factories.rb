FactoryGirl.define do
  factory :profile do
    sequence(:name) { |n| "#{n}"}
    parent_profile_id  ""
  end
  
  factory :result do
    sequence(:date) { |n| "#{n}"}
    profile
  end

  factory :sequence do
    sequence(:seq) { |n| "#{n}" }
  end
end
