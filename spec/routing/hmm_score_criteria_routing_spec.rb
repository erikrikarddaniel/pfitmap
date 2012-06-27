require "spec_helper"

describe HmmScoreCriteriaController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_score_criteria").should route_to("hmm_score_criteria#index")
    end

    it "routes to #new" do
      get("/hmm_score_criteria/new").should route_to("hmm_score_criteria#new")
    end

    it "routes to #show" do
      get("/hmm_score_criteria/1").should route_to("hmm_score_criteria#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hmm_score_criteria/1/edit").should route_to("hmm_score_criteria#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hmm_score_criteria").should route_to("hmm_score_criteria#create")
    end

    it "routes to #update" do
      put("/hmm_score_criteria/1").should route_to("hmm_score_criteria#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hmm_score_criteria/1").should route_to("hmm_score_criteria#destroy", :id => "1")
    end

  end
end
