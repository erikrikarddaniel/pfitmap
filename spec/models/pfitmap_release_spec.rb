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

  describe "without current" do
    before{ @pfitmap_release.current = nil }
    it { should_not be_valid }
  end

  describe "without release" do
    before{ @pfitmap_release.release = nil }
    it { should_not be_valid }
  end
  
  describe "without release date" do
    before{ @pfitmap_release.release_date = nil }
    it { should_not be_valid }
  end
  
end
