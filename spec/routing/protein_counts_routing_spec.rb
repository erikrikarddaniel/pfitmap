require "spec_helper"

describe ProteinCountsController do
  describe "routing" do

    it "routes to #index" do
      get("/protein_counts").should route_to("protein_counts#index")
    end

    it "routes to #new" do
      get("/protein_counts/new").should route_to("protein_counts#new")
    end

    it "routes to #show" do
      get("/protein_counts/1").should route_to("protein_counts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/protein_counts/1/edit").should route_to("protein_counts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/protein_counts").should route_to("protein_counts#create")
    end

    it "routes to #update" do
      put("/protein_counts/1").should route_to("protein_counts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/protein_counts/1").should route_to("protein_counts#destroy", :id => "1")
    end

  end
end
