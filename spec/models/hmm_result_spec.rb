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

  describe "More complex hmm_result" do
    before(:each) do
      @hmm_result_nrdb = FactoryGirl.create(:hmm_result_nrdb)
      # Read a real data file to create rows (this duplicates implementation code...)
      File.open("#{Rails.root}/data/example_data/NrdB.tblout").each do |hmmline|
	fields = hmmline.chomp.split(/\s+/)
	dbhit = "#{fields[0]} #{fields[17..-1].join(" ")}".split(/\001/).find do |dbs|
	  gifields = dbs.split("|")
          HmmDbHit.find_by_gi(gifields[1].to_i) 
	end
	db_sequence = ( dbhit ? dbhit.db_sequence : DbSequence.create() )
	row = @hmm_result_nrdb.hmm_result_rows.create!(
	  target_name:		fields[0],
	  target_acc:		fields[0].split('|')[2..3].join(':'),
	  query_name:		fields[2],
	  query_acc:		fields[3],
	  fullseq_evalue:	fields[4].to_f,
	  fullseq_score:	fields[5].to_f,
	  fullseq_bias:		fields[6].to_f,
	  bestdom_evalue:	fields[7].to_f,
	  bestdom_score:	fields[8].to_f,
	  bestdom_bias:		fields[9].to_f,
	  domnumest_exp:	fields[10].to_f,
	  domnumest_reg:	fields[11].to_i,
	  domnumest_clu:	fields[12].to_i,
	  domnumest_ov:		fields[13].to_i,
	  domnumest_env:	fields[14].to_i,
	  domnumest_dom:	fields[15].to_i,
	  domnumest_rep:	fields[16].to_i,
	  domnumest_inc:	fields[17].to_i,
	  db_sequence:		db_sequence
	)
      end
    end

    it 'should have the correct hmm_profile' do
      @hmm_result_nrdb.hmm_profile.name.should == 'Class I RNR radical generating subunit'
    end
  end

end
