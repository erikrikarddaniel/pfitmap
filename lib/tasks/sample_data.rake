namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_hmm_profiles
    make_sequence_db
    # make_hmm_results
    # make_hmm_result_rows
    # make_hmm_db_hits
    # make_hmm_result_rows_hmm_db_hits
  end


def make_hmm_profiles
    HmmProfile.create!(name: "Example Root Profile", version: "Some version", hierarchy: "000")
    @hmm_profile = HmmProfile.find_by_hierarchy("000")
    9.times do |n|
      name = "Example Profile #{n+1}"
      HmmProfile.create!(name: name, version: "Some version", hierarchy: "000.00#{n}", parent_id: @hmm_profile.id)
    end
end

def make_sequence_db
    SequenceDb.create!(name: "ref", source: "NCBI", version: "1899-12-24")
end
  
def make_results
    profiles = HmmProfile.all
    5.times do |n|
      executed = n.day.ago
      profiles.each { |profile| profile.results.create!(date: date) }
    end
end

def make_sequences
    counts = {'R'=>5,'L'=>7,'E'=>3,'A'=>4}
    50.times do |n|
      sequence = (0...50).map{ ['A','L', 'R', 'E'].to_a[rand(50)] }.join
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