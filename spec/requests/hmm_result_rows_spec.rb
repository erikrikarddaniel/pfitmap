require 'spec_helper'

describe "HmmResultRows" do
  describe "GET /hmm_result_rows" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hmm_result_rows_path
      response.status.should be(200)
    end
  end
end
