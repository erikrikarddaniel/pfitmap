# == Schema Information
#
# Table name: db_sequences
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  sequence   :text
#

require 'spec_helper'
require 'file_parsers'

include FileParsers

describe DbSequence do
  let!(:hmm_profile) { FactoryGirl.create(:hmm_profile_nrdbr2lox) }
  let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile) }
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  let!(:hmm_result) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile, sequence_source: sequence_source, executed: 100.years.ago) }
  before do
    @db_sequence = DbSequence.new()
  end
  subject { @db_sequence }

  it { should respond_to(:id) }
  it { should respond_to(:hmm_result_rows)}
  it { should respond_to(:hmm_db_hits) }
  it { should respond_to(:pfitmap_sequences) }
  it { should respond_to(:db_sequence_best_profiles) }

  # Methods
  it { should respond_to(:all_hits) }
  it { should respond_to(:best_hmm_profiles) }
  it { should respond_to(:best_hmm_result_row) }
  it { should respond_to(:best_hmm_profiles_for) }

  describe "with valid parameters" do
    it {should be_valid}
  end
  
  describe "create with factory" do
    let(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    before do
      @hmm_db_hit = HmmDbHit.create(gi: "9999", db: "ref", acc: "ABCD", db_sequence_id: db_sequence.id)
    end
    subject{ @hmm_db_hit }
    it { should be_valid}
  end

  describe "listing all hits" do
    let(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    subject{db_sequence.all_hits(sequence_source)}
    it {should include(hmm_result_row)}
  end

  describe "best- methods" do
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_result2) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile2, sequence_source: sequence_source, executed: 100.years.ago) }
    let!(:hmm_result_row) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result, db_sequence: db_sequence) }
    #Create a second result row with lower score
    let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result2, db_sequence: db_sequence) }
    
    context "with only one result and one result row" do
      
      describe "best hmm profiles" do
        it "is hmm_profile" do
          db_sequence.best_hmm_profiles_for(sequence_source).should == [hmm_profile]
        end

        it "is hmm profile" do
          db_sequence.best_hmm_profiles.should == [hmm_profile]
        end
      end

      describe "best hmm result row" do
        it "finds the best row" do
          db_sequence.best_hmm_result_row(sequence_source).should eq(hmm_result_row)
        end
        it "should have a higher score" do
          db_sequence.best_hmm_result_row(sequence_source).fullseq_score.should be > hmm_result_row2.fullseq_score
        end
      end
    end

    context "with two result rows" do
      #Create a second result row with lower score
      let!(:hmm_result_row2) { FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result2, db_sequence: db_sequence) }
      describe "best hmm profiles" do
        subject { db_sequence}
        it "is hmm_profiles" do
          db_sequence.best_hmm_profiles_for(sequence_source).should == [hmm_profile]
        end
        
        
        it "is hmm_profiles" do
          db_sequence.best_hmm_profiles.should == [hmm_profile]
        end
      end
      
      
      describe "best hmm result row" do
        subject { db_sequence }
        it "is hmm_result_row" do
          db_sequence.best_hmm_result_row(sequence_source).should eq(hmm_result_row)
        end
        it "should have a higher score" do
          db_sequence.best_hmm_result_row(sequence_source).fullseq_score.should be > hmm_result_row2.fullseq_score
        end
      end
    end
    
    context "with two sequence sources and profiles" do
      let!(:sequence_source2) { FactoryGirl.create(:sequence_source_older) }
      let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile) }
      let!(:hmm_result3) { FactoryGirl.create(:hmm_result, sequence_source: sequence_source2, hmm_profile: hmm_profile2) }
      let!(:hmm_result_row3) { FactoryGirl.create(:hmm_result_row2, hmm_result: hmm_result3, db_sequence: db_sequence) }
      
      
      describe "best hmm profiles" do
        it "is hmm_profile" do
          db_sequence.best_hmm_profiles_for(sequence_source).should == [hmm_profile]
        end
      
        it "is hmm profile" do
          db_sequence.best_hmm_profiles.should include(hmm_profile)
          db_sequence.best_hmm_profiles.should include(hmm_profile2)
        end
      end

      describe "best hmm result row" do
        subject { db_sequence }
        it "is hmm_result_row" do
          db_sequence.best_hmm_result_row(sequence_source).should eq(hmm_result_row)
        end
        it "should have a higher score" do
          db_sequence.best_hmm_result_row(sequence_source).fullseq_score.should be > hmm_result_row2.fullseq_score
        end
      end
    end
  end

  describe "pfitmap sequence" do
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    subject{db_sequence}
    describe "can be null" do
      its(:pfitmap_sequences) { should == [] }
    end
    describe "can be correct" do
      let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence) }
      its(:pfitmap_sequences) { should include(pfitmap_sequence) }
    end
  end

  describe "fasta import" do
    it "will update sequence on all db_sequence objects" do
      hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      parse_hmm_tblout(hmm_result_nrdb, fixture_file_upload("/NrdB.test.tblout"))
      parse_fasta(fixture_file_upload("/NrdB.test.fasta"))
      DbSequence.where("sequence IS NULL").length.should == 0
    end

#    it "will update sequence on all db_sequence objects also for large files without taking too long" do
#      hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
#      parse_hmm_tblout(hmm_result_nrdb, fixture_file_upload("/NrdB.tblout"))
#      parse_fasta(fixture_file_upload("/NrdB.fasta"))
#      DbSequence.where("sequence IS NULL").length.should == 0
#    end
  end
end
