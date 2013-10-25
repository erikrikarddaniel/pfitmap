# == Schema Information
#
# Table name: released_dbs
#
#  id                 :integer         not null, primary key
#  pfitmap_release_id :integer
#  load_database_id   :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe ReleasedDb do
  let!(:load_database) {FactoryGirl.create(:load_database)}
  let!(:pfitmap_release) {FactoryGirl.create(:pfitmap_release)}
  before do
    @rd = ReleasedDb.create()
    @rd.load_database = load_database
    @rd.pfitmap_release = pfitmap_release
    @rd.save
  end
  it "should be valid" do
    @rd.should be_valid
  end

  it "should have correct load database" do
    @rd.load_database.should == load_database
  end
  it "should have correct pfitmap release" do
    @rd.pfitmap_release.should == pfitmap_release
  end
end
