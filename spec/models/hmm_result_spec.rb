# == Schema Information
#
# Table name: hmm_results
#
#  id                 :integer         not null, primary key
#  executed           :datetime
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  hmm_profile_id     :integer
#  sequence_source_id :integer         not null
#

require 'spec_helper'
require 'file_parsers'

include FileParsers

describe HmmResult do
  let(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
  let(:sequence_source) { FactoryGirl.create(:sequence_source) }
  before { @result = hmm_profile.hmm_results.build(executed: "20110318", sequence_source_id: sequence_source.id )}
  
  subject { @result }
  
  it { should respond_to(:executed) }
  it { should respond_to(:sequence_source_id) }
  it { should respond_to(:hmm_result_rows) }
  it { should respond_to(:hmm_profile_id) }
  it { should respond_to(:hmm_profile) }
  
  it { should be_valid }
  
  describe "should not be valid when hmm_profile_id is not present" do
    before { @result.hmm_profile_id = nil }
    it { should_not be_valid }
  end

  describe "should be valid after test" do
    it { should be_valid }
  end

  describe "should not be valid when sequence_source is not present" do
    before { @result.sequence_source_id = nil }
    it { should_not be_valid }
  end

  describe "should find its owner profile" do
    its(:hmm_profile) { should == hmm_profile }
  end

  describe "should have unique combination of profile and db" do
    before do
      @result.save!
      @result_bogus = hmm_profile.hmm_results.build(executed: "20110401", sequence_source_id: sequence_source.id) 
    end
    subject { @result_bogus }
    it { should_not be_valid }
  end

  describe "Simple import cases" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
    end

    it "should correctly import a file with embedded '#':s on one row" do
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/problematic_rows00.tblout"))
      hmm_db_hits = @hmm_result_nrdb.hmm_result_rows.map { |hrr| hrr.db_sequence.hmm_db_hits }.flatten
      hmm_db_hits.length.should == 27
      hmm_db_hits.map { |h| h.gi }.should include(15619738)
    end
  end

  describe "More complex hmm_result" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      parse_hmm_tblout(@hmm_result_nrdb, fixture_file_upload("/NrdB.tblout"))
    end

    it 'should have the correct hmm_profile' do
      @hmm_result_nrdb.hmm_profile.name.should == 'Class I RNR radical generating subunit'
    end

    it 'should have the correct number of hmm_result_rows' do
      @hmm_result_nrdb.hmm_result_rows.length.should == 241
    end

    it 'should have the correct number of hmm_db_hits' do
      hmm_db_hits = @hmm_result_nrdb.hmm_result_rows.map { |hrr| hrr.db_sequence.hmm_db_hits }.flatten
      hmm_db_hits.map { |h| h.gi }.should include(95109514)
      hmm_db_hits.length.should == 709
    end
  end
end
