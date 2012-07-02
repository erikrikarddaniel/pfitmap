# == Schema Information
#
# Table name: enzymes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Enzyme do
  before do
    @enzyme = Enzyme.new(name: "RNR EX")
  end
  subject{ @enzyme }

  it { should respond_to(:name) }
  it { should respond_to(:hmm_profiles) }
  it { should respond_to(:enzyme_profiles) }

  describe "relations" do
    let!(:hmm_profile) { FactoryGirl.create(:hmm_profile) }
    let!(:enzyme) { FactoryGirl.create(:enzyme) }
    let!(:enzyme_profile) { FactoryGirl.create(:enzyme_profile, enzyme: enzyme, hmm_profile: hmm_profile) }
    subject{enzyme}
    
    its(:hmm_profiles) { should include(hmm_profile) }
  end
end
