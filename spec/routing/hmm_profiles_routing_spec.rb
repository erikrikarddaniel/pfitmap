require "spec_helper"

describe HmmProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_profiles").should route_to("hmm_profiles#index")
    end

    it "routes to #new" do
      get("/hmm_profiles/new").should route_to("hmm_profiles#new")
    end

    it "routes to #show" do
      get("/hmm_profiles/1").should route_to("hmm_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hmm_profiles/1/edit").should route_to("hmm_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hmm_profiles").should route_to("hmm_profiles#create")
    end

    it "routes to #update" do
      put("/hmm_profiles/1").should route_to("hmm_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hmm_profiles/1").should route_to("hmm_profiles#destroy", :id => "1")
    end

  end
end
