namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Profile.create!(name: "Example Profile")
    99.times do |n|
      name = "Example Profile #{n+1}"
      Profile.create!(name: name)
    end
    profiles = Profile.all(limit: 6)
    25.times do |n|
      date  = n.day.ago
      profiles.each { |profile| profile.results.create!(date: date) }
      profiles.each { |profile| profile.results.create!(date: date) }
    end
  end
end