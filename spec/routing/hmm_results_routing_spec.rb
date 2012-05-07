require "spec_helper"

describe HmmResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_results").should route_to("hmm_results#index")
    end

    it "does not route to #new" do
      get("/hmm_results/new").should_not route_to("hmm_results#new")
    end

    it "routes to #show" do
      get("/hmm_results/1").should route_to("hmm_results#show", :id => "1")
    end

    it "does not route to #edit" do
      pending "should not route to edit"
      get("/hmm_results/1/edit").response.should_not be(200)
    end

    it "routes to #create" do
      post("/hmm_results").should route_to("hmm_results#create")
    end

    it "routes to #update" do
      put("/hmm_results/1").should route_to("hmm_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hmm_results/1").should route_to("hmm_results#destroy", :id => "1")
    end

  end
end
