# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  role       :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "jonas", email: "jonas@example.com")
    @user.provider = "open_id"
    @user.uid = "ex123456"
  end
  subject{ @user }

  it { should be_valid }
  
  describe "only one per id/provider" do
    let!(:user) { FactoryGirl.create(:user) }
    it {should_not be_valid }
  end
end
