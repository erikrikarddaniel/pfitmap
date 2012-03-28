require "spec_helper"

describe HmmResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_results").should route_to("hmm_results#index")
    end

    it "routes to #new" do
      get("/hmm_results/new").should route_to("hmm_results#new")
    end

    it "routes to #show" do
      get("/hmm_results/1").should route_to("hmm_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hmm_results/1/edit").should route_to("hmm_results#edit", :id => "1")
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
