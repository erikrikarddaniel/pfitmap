# == Schema Information
#
# Table name: sequence_databases
#
#  id            :integer         not null, primary key
#  db            :string(255)
#  abbreviation  :string(255)
#  home_page     :string(255)
#  accession_url :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe SequenceDatabase do
  let!(:db_entry) {FactoryGirl.create(:db_entry)}
  before do
    @sd = SequenceDatabase.create(db:"ref",abbreviation:"ref test",home_page:"http://mbl.is",accession_url:"http://mbl.is/test.json")
  end
  it "should be valid" do
    @sd.should be_valid
  end
  it "should have one db entry" do
    @sd.db_entries.length.should == 1
  end
end
