# == Schema Information
#
# Table name: pfitmap_releases
#
#  id           :integer         not null, primary key
#  release      :string(255)
#  release_date :date
#  current      :boolean
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe PfitmapRelease do
  before do
    @pfitmap_release = PfitmapRelease.new(release: "0.1", release_date: "2001-04-20",current: false)
  end
  subject{ @pfitmap_release }

  it { should be_valid }
  it { should respond_to(:release) }
  it { should respond_to(:release_date) }
  it { should respond_to(:current) }
  it { should respond_to(:pfitmap_sequences) }
  it { should respond_to(:db_sequences) }

  describe "current" do
    describe "without current" do
      before{ @pfitmap_release.current = nil }
      it { should_not be_valid }
    end

    describe "only one at a time" do
      before do
        @pfitmap_release2 = PfitmapRelease.create!(release: "0.2", release_date: "2001-04-21", current: true)
        @pfitmap_release.current = true
      end
      it { should_not be_valid }
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
    let!(:pfitmap_sequence) { FactoryGirl.create(:pfitmap_sequence, db_sequence: db_sequence, pfitmap_release: @pfitmap_release) }
    let!(:pfitmap_release) { FactoryGirl.create(:pfitmap_release) }
    it { should respond_to :add_seq_to_head }
  end
end
