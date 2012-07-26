# == Schema Information
#
# Table name: pfitmap_releases
#
#  id                 :integer         not null, primary key
#  release            :string(255)
#  release_date       :date
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  current            :boolean
#  sequence_source_id :integer
#

require 'spec_helper'

describe PfitmapRelease do
  let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
  before do
    @pfitmap_release = PfitmapRelease.new(release: "0.1", release_date: "2001-04-20", sequence_source_id: sequence_source)
    @pfitmap_release.current = false
  end
  subject{ @pfitmap_release }
  
  it { should be_valid }
  
  describe "sequence source association" do
    describe "without it" do
      before do
        @pfitmap_release.sequence_source_id = nil
      end
      it { should_not be_valid }
    end
    describe "uniqueness" do
      before do
        @sequence_source = SequenceSource.create(source: "NCBI", name: "NR", version: "20120709")
        @pfitmap_release_mock = PfitmapRelease.new(release: "2.0", release_date: "20120709", sequence_source_id: @sequence_source.id)
        @pfitmap_release_mock.current = false
        @pfitmap_release_mock.save
        @pfitmap_release.sequence_source_id = @sequence_source.id
      end
      it "has a taken value for source" do
        @pfitmap_release.should_not be_valid
      end
    end
  end

  

  it { should respond_to(:release) }
  it { should respond_to(:release_date) }
  it { should respond_to(:pfitmap_sequences) }
  it { should respond_to(:db_sequences) }
  it { should respond_to(:add_seq) }
  it { should respond_to(:sequence_source) }

  describe "class methods" do
    subject{ PfitmapRelease }
    it { should respond_to(:find_current_release) }
    it { should respond_to(:find_all_after_current) }
  end

  describe "find current release" do
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
    let!(:sequence_source2) { FactoryGirl.create(:sequence_source) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: sequence_source2) }
    it "returns the current release" do
      PfitmapRelease.find_current_release.should == pfitmap_release2
    end
  end

  describe "find all after current" do
    let!(:sequence_source3) { FactoryGirl.create(:sequence_source) }
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true, sequence_source: sequence_source3) }
let!(:sequence_source4) { FactoryGirl.create(:sequence_source) }
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source4) }
let!(:sequence_source5) { FactoryGirl.create(:sequence_source) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source5) }

    it "returns the correct releases" do
      PfitmapRelease.find_all_after_current.should include(pfitmap_release1)
      PfitmapRelease.find_all_after_current.should include(pfitmap_release2)
      PfitmapRelease.find_all_after_current.should_not include(pfitmap_release)
    end
  end

  describe "without release" do
    before{ @pfitmap_release.release = nil }
    it { should_not be_valid }
  end
  
  describe "without release date" do
    before{ @pfitmap_release.release_date = nil }
    it { should_not be_valid }
  end
  
  describe "associations" do
    let!(:pfitmap_release1) {FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }

    let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence, pfitmap_release: pfitmap_release1) }
    
    it "has correct associations" do
      pfitmap_release1.db_sequences.should include(db_sequence)
      pfitmap_release1.pfitmap_sequences.should include(pfitmap_sequence)
    end
  end

  describe "add sequence to head" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    let!(:pfitmap_release_not_current) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source) }
    let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, 
                                                 db_sequence: db_sequence1, 
                                                 pfitmap_release: pfitmap_release_not_current) }
    
    describe "adds to the correct release" do
      let!(:current_release) { FactoryGirl.create(:pfitmap_release) }
      before do
        current_release.add_seq(db_sequence2, hmm_profile )
      end

      it "adds to the correct release" do
        current_release.db_sequences.should include(db_sequence2)
      end
    end
    
    describe "an already existing sequence" do
      let!(:db_sequence3){ FactoryGirl.create(:db_sequence) }
      let!(:sequence_source6) { FactoryGirl.create(:sequence_source) }
      let!(:pfitmap_release_current) { FactoryGirl.create(:pfitmap_release, sequence_source: sequence_source6) }
      let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence,
                                                   db_sequence: db_sequence3,
                                                   pfitmap_release: pfitmap_release_current
                                                   ) }
      before do
        pfitmap_release_current.add_seq(db_sequence3, hmm_profile)
      end
      subject{ pfitmap_release_current }
      its(:db_sequences) { should include(db_sequence3) }
    end
  end

  
  describe "build hash" do
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:hmm_db_hit1) { FactoryGirl.create(:hmm_db_hit, gi: 297089704, db: "ref", db_sequence: db_sequence1) }
    let!(:hmm_db_hit2) { FactoryGirl.create(:hmm_db_hit, gi: 297089710, db: "pdb", db_sequence: db_sequence1) }
    let!(:hmm_db_hit3) { FactoryGirl.create(:hmm_db_hit, gi: 297089654, db: "pdb", db_sequence: db_sequence1) }
    
    let!(:pfitmap_release) {FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_sequence) {FactoryGirl.create(:pfitmap_sequence, pfitmap_release: pfitmap_release, db_sequence: db_sequence1) }
    it "should give the correct taxons back" do
      gi_taxons = HmmDbHit.all_taxons_for(pfitmap_release)
      hash = pfitmap_release.build_gi_ncbi_taxon_hash(gi_taxons)
      hash[297089704].should == 767985
      hash[297089710].should == 767985
      hash[297089654].should_not == 767985
      hash[297089654].should == 767981
    end
  end


end
