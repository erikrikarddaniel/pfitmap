# == Schema Information
#
# Table name: load_databases
#
#  id                   :integer         not null, primary key
#  taxonset             :string(255)
#  name                 :string(255)
#  description          :string(255)
#  active               :boolean
#  sequence_database_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

require 'spec_helper'

describe LoadDatabase do
  let!(:sequence_database) {FactoryGirl.create(:sequence_database)}

  before do
    @ld = LoadDatabase.create(taxonset: "restful_URL", name: "ref + wgs", description: "ref wgs description",active: true,sequence_database_id: sequence_database.id)
  end
  it "should be valid" do
    @ld.should be_valid
  end 

  it "should have sequence database" do
    @ld.sequence_database.should == sequence_database
  end
end
