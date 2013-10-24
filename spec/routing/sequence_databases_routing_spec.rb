require "spec_helper"

describe SequenceDatabasesController do
  describe "routing" do

    it "routes to #index" do
      get("/sequence_databases").should route_to("sequence_databases#index")
    end

    it "routes to #new" do
      get("/sequence_databases/new").should route_to("sequence_databases#new")
    end

    it "routes to #show" do
      get("/sequence_databases/1").should route_to("sequence_databases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sequence_databases/1/edit").should route_to("sequence_databases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sequence_databases").should route_to("sequence_databases#create")
    end

    it "routes to #update" do
      put("/sequence_databases/1").should route_to("sequence_databases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sequence_databases/1").should route_to("sequence_databases#destroy", :id => "1")
    end

  end
end
