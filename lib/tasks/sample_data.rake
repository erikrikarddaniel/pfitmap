namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_hmm_profiles
    make_sequence_sources
    make_hmm_score_criteria
  end


def make_hmm_profiles
    HmmProfile.create!(name: "RNR R2 and R2lox", version: "20120402", hierarchy: "001")
    @hmm_profile_001 = HmmProfile.find_by_hierarchy("001")
    @hmm_profile_00100 = HmmProfile.create!(name: "RNR R2", protein_name: "NrdB", version: "20120402", hierarchy: "001.00", parent_id: @hmm_profile_001.id)
    HmmProfile.create!(name: "RNR R2 Child1", protein_name: "NrdF", version: "20120402", hierarchy: "001.00.00", parent_id: @hmm_profile_00100.id)
    HmmProfile.create!(name: "RNR R2 Child2", version: "20120402", hierarchy: "001.00.01", parent_id: @hmm_profile_00100.id)
    HmmProfile.create!(name: "R2lox", version: "20120402", hierarchy: "001.01", parent_id: @hmm_profile_001.id)
    HmmProfile.create!(name: "RNR R1 and PFL", version: "20120402", hierarchy: "000")
    
end

def make_hmm_score_criteria
    HmmScoreCriterion.create!(hmm_profile_id: HmmProfile.find_by_hierarchy("001.00").id, min_fullseq_score: 20)
    HmmScoreCriterion.create!(hmm_profile_id: HmmProfile.find_by_hierarchy("001.00.00").id, min_fullseq_score: 30)
    HmmScoreCriterion.create!(hmm_profile_id: HmmProfile.find_by_hierarchy("001.00.01").id, min_fullseq_score: 50)
end


def make_sequence_sources
    SequenceSource.create!(name: "NR", source: "NCBI", version: "1899-12-24")
    SequenceSource.create!(name: "NR", source: "NCBI", version: "1899-04-01")
end
end
