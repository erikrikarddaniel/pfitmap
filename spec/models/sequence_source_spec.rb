# == Schema Information
#
# Table name: sequence_sources
#
#  id         :integer         not null, primary key
#  source     :string(255)
#  name       :string(255)
#  version    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe SequenceSource do
  before(:each) do
    @attr = {
      :source => "NCBI",
      :name => "NR",
      :version => "20120328"
    }
    @seqdb = SequenceSource.new(@attr)
  end

  subject { @seqdb }

  it { should respond_to(:source) }
  it { should respond_to(:hmm_results) }
  it { should respond_to(:hmm_profiles) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:db_sequences) }
  it { should respond_to(:view_db_sequence_best_profiles) }
  it { should respond_to(:list_name) }
  it { should respond_to(:pfitmap_release) }
  it { should be_valid }

  describe "Should not be valid when source is not present" do
    before { @seqdb.source = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when name is not present" do
    before { @seqdb.name = "" }
    it { should_not be_valid }
  end

  describe "Should not be valid when version is not present" do
    before { @seqdb.version = "" }
    it { should_not be_valid }
  end
  
  describe "associations" do
    let!(:hmm_profile1) { FactoryGirl.create(:hmm_profile) }
    let!(:hmm_profile2) { FactoryGirl.create(:hmm_profile_nrdbr2lox) }
    let!(:hmm_profile3) { FactoryGirl.create(:hmm_profile_nrdb) }
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:hmm_result1) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile1, sequence_source: sequence_source) }
    let!(:hmm_result3) { FactoryGirl.create(:hmm_result, hmm_profile: hmm_profile3, sequence_source: sequence_source) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_result_row1) { FactoryGirl.create(:hmm_result_row, hmm_result: hmm_result1, db_sequence: db_sequence1) }

    subject{sequence_source}

    describe "all profiles available in results" do 
      its(:hmm_profiles) { should include(hmm_profile1) }
      its(:hmm_profiles) { should_not include(hmm_profile2) }
      its(:hmm_profiles) { should include(hmm_profile3) }
    end

    describe "all results" do
      its(:hmm_results) { should include(hmm_result1) }
      its(:hmm_results) { should include(hmm_result3) }
    end
    
    describe "all result rows available in results" do
      its(:hmm_result_rows) { should include(hmm_result_row1) }
    end
    
    describe "all result rows available in results" do
      its(:db_sequences) { should include(db_sequence1) }
    end
  end

  describe "a correct list name" do
    its(:list_name) { should ==("NCBI:NR:20120328") }
  end
 

  describe "evaluate" do
    describe "with a single complex factory" do
      before(:each) do
        @hmm_result_nrdbe = FactoryGirl.create(:hmm_result_nrdbe)
        @sequence_source = @hmm_result_nrdbe.sequence_source
        @pfitmap_release = FactoryGirl.create(:pfitmap_release, sequence_source: @sequence_source)
        parse_hmm_tblout(@hmm_result_nrdbe, fixture_file_upload("/NrdBe-20rows.tblout"))
        @sequence_source.evaluate(@pfitmap_release,nil)
      end

      it "should have imported all rows from the table" do
        HmmResultRow.all.length.should == 23
        DbSequence.all.length.should == 23
      end
   
      it "should not add rows with score lower than 400 to pfitmap" do
        PfitmapSequence.all.length.should == 21
        @pfitmap_release.pfitmap_sequences.length.should == 21
      end
    end

    describe "with two complex factories" do
      before(:each) do
        @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
        @sequence_source = @hmm_result_nrdb.sequence_source
        @hmm_result_nrdbe = FactoryGirl.create(:hmm_result_nrdbe, sequence_source: @sequence_source)
        @pfitmap_release = FactoryGirl.create(:pfitmap_release, sequence_source: @sequence_source)
        parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB-20rows.tblout"))
        parse_hmm_tblout(@hmm_result_nrdbe, fixture_file_upload("/NrdBe-20rows.tblout"))
        @sequence_source.evaluate(@pfitmap_release,nil)
      end
      
      it "should have imported all rows from the tables" do
        @hmm_result_nrdb.hmm_result_rows.length.should == 19
        @hmm_result_nrdbe.hmm_result_rows.length.should == 23
        DbSequence.all.length.should == 39
      end

      it "should add all db_sequences to pfitmap" do
        PfitmapSequence.all.length.should == 39
        @pfitmap_release.pfitmap_sequences.length.should == 39
      end
    end
  end
end
