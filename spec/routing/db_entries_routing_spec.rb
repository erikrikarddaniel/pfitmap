require "spec_helper"

describe HmmDbHitsController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_db_hits").should route_to("hmm_db_hits#index")
    end

    it "routes to #new" do
      get("/hmm_db_hits/new").should route_to("hmm_db_hits#new")
    end

    it "routes to #show" do
      get("/hmm_db_hits/1").should route_to("hmm_db_hits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hmm_db_hits/1/edit").should route_to("hmm_db_hits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hmm_db_hits").should route_to("hmm_db_hits#create")
    end

    it "routes to #update" do
      put("/hmm_db_hits/1").should route_to("hmm_db_hits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hmm_db_hits/1").should route_to("hmm_db_hits#destroy", :id => "1")
    end

  end
end
