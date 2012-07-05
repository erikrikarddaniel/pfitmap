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
  before do
    @pfitmap_release = PfitmapRelease.new(release: "0.1", release_date: "2001-04-20")
    @pfitmap_release.current = false
  end
  subject{ @pfitmap_release }
  
  it { should be_valid }
  it { should respond_to(:release) }
  it { should respond_to(:release_date) }
  it { should respond_to(:pfitmap_sequences) }
  it { should respond_to(:db_sequences) }
  it { should respond_to(:add_seq) }

  describe "class methods" do
    subject{ PfitmapRelease }
    it { should respond_to(:find_current_release) }
    it { should respond_to(:find_all_after_current) }
  end

  describe "find current release" do
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release, current: true) }
    it "returns the current release" do
      PfitmapRelease.find_current_release.should == pfitmap_release2
    end
  end

  describe "find all after current" do
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release, current: true) }
    let!(:pfitmap_release1) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_release2) { FactoryGirl.create(:pfitmap_release) }

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
    let!(:db_sequence) { FactoryGirl.create(:db_sequence) }
    let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence, pfitmap_release: @pfitmap_release) }
    
    its(:db_sequences) { should include(db_sequence) }
    its(:pfitmap_sequences) { should include(pfitmap_sequence) }
  end

  describe "add sequence to head" do
    let!(:db_sequence1) { FactoryGirl.create(:db_sequence) }
    let!(:db_sequence2) { FactoryGirl.create(:db_sequence) }
    let!(:pfitmap_release_not_current) { FactoryGirl.create(:pfitmap_release) }
    let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, 
                                                 db_sequence: db_sequence1, 
                                                 pfitmap_release: pfitmap_release_not_current) }
    
    describe "adds to the correct release" do
      before do
        @current_release = PfitmapRelease.new(release: "1.2",
                                                  release_date: "2012-06-10",
                                                  )
        @current_release.current = 'true'
        @current_release.save
        @current_release.add_seq(db_sequence2)
      end
      subject { @current_release }

      its(:db_sequences) { should include(db_sequence2) }
      its(:db_sequences) { should_not include(db_sequence1) }
    end
    
    describe "an already existing sequence" do
      let!(:db_sequence3){ FactoryGirl.create(:db_sequence) }
      let!(:pfitmap_release_current) { FactoryGirl.create(:pfitmap_release) }
      let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence,
                                                   db_sequence: db_sequence3,
                                                   pfitmap_release: pfitmap_release_current
                                                   ) }
      before do
        pfitmap_release_current.add_seq(db_sequence3)
      end
      subject{ pfitmap_release_current }
      its(:db_sequences) { should include(db_sequence3) }
    end
  end
end
