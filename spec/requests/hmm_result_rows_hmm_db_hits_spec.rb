require 'spec_helper'

describe "HmmResultRowsHmmDbHits" do
  describe "GET /hmm_result_rows_hmm_db_hits" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get hmm_result_rows_hmm_db_hits_path
      response.status.should be(200)
    end
  end
end
