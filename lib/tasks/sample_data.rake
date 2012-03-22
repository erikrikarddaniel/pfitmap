namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_profiles
    make_results
    make_result_rows
    make_sequences
  end


def make_profiles
    Profile.create!(name: "Example Profile")
    99.times do |n|
      name = "Example Profile #{n+1}"
      Profile.create!(name: name)
    end
end

def make_results
    profiles = Profile.all(limit: 6)
    25.times do |n|
      date  = n.day.ago
      profiles.each { |profile| profile.results.create!(date: date) }
      profiles.each { |profile| profile.results.create!(date: date) }
    end
end

def make_sequences
    counts = {'R'=>5,'L'=>7,'E'=>3,'A'=>4}
    50.times do |n|
      sequence = (0...50).map{ ['A','L', 'R', 'E'].to_a[rand(26)] }.join
      Sequence.create!(seq: sequence)
    end
end

def make_result_rows
    results = Result.all()
    results.each { |result| result.result_rows.create!() }
end

def make_result_rows_sequences
    sequences = Sequence.all()
    resultRows = ResultRow.all()
    sequences.each do |n1|
      resultRows.each do |n2|
        ResultRowsSequence.create!(sequence_id: n1.id, result_row_id: n2.id)
      end
    end
end
end