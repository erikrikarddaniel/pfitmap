require "spec_helper"

describe ProteinCountsController do
  describe "routing" do
    it "routes to #by_hierarchy" do
      get("/protein_counts_by_hierarchy").should route_to("protein_counts#by_hierarchy")
    end
    
    it "routes to #by_rank" do
      get("/protein_counts_by_rank").should route_to("protein_counts#by_rank")
    end

  end
end
