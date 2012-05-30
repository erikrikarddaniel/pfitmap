require "spec_helper"

describe SequenceSourcesController do
  describe "routing" do

    it "routes to #index" do
      get("/sequence_sources").should route_to("sequence_sources#index")
    end

    it "routes to #new" do
      get("/sequence_sources/new").should route_to("sequence_sources#new")
    end

    it "routes to #show" do
      get("/sequence_sources/1").should route_to("sequence_sources#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sequence_sources/1/edit").should route_to("sequence_sources#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sequence_sources").should route_to("sequence_sources#create")
    end

    it "routes to #update" do
      put("/sequence_sources/1").should route_to("sequence_sources#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sequence_sources/1").should route_to("sequence_sources#destroy", :id => "1")
    end

  end
end
