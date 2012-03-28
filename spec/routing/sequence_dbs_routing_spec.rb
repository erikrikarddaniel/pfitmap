require "spec_helper"

describe SequenceDbsController do
  describe "routing" do

    it "routes to #index" do
      get("/sequence_dbs").should route_to("sequence_dbs#index")
    end

    it "routes to #new" do
      get("/sequence_dbs/new").should route_to("sequence_dbs#new")
    end

    it "routes to #show" do
      get("/sequence_dbs/1").should route_to("sequence_dbs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sequence_dbs/1/edit").should route_to("sequence_dbs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sequence_dbs").should route_to("sequence_dbs#create")
    end

    it "routes to #update" do
      put("/sequence_dbs/1").should route_to("sequence_dbs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sequence_dbs/1").should route_to("sequence_dbs#destroy", :id => "1")
    end

  end
end
