require "spec_helper"

describe ProteinCountsController do
  describe "routing" do
    it "routes to #with_enzymes" do
      get("/protein_counts_with_enzymes").should route_to("protein_counts#with_enzymes")
    end
  end
end
