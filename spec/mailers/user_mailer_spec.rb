require "spec_helper"

describe UserMailer do

  describe "evaluate_success_email" do
    let!(:sequence_source) { FactoryGirl.create(:sequence_source) }
    let!(:user){ FactoryGirl.create(:user) }

    it "should deliver the mail" do
      lambda { UserMailer.evaluate_success_email(user, sequence_source).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end
  end
end
