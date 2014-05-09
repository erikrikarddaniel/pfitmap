# == Schema Information
#
# Table name: configurable_params
#
#  id         :integer         not null, primary key
#  param      :string(255)
#  value      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe ConfigurableParam do
  before do
    @params = { param: 'FETCH_SIZE', value: '50000' }
    @fetch_size = ConfigurableParam.new(@params)
  end

  subject { @fetch_size }

  it {  should be_valid }

  describe "only one with the same 'param' value" do
    let!(:fetch_size) { FactoryGirl.create(:configurable_param) }
    it {  should_not be_valid }
  end
end
