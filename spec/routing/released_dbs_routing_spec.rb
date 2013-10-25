require "spec_helper"

describe ReleasedDbsController do
  describe "routing" do

    it "routes to #index" do
      get("/released_dbs").should route_to("released_dbs#index")
    end

    it "routes to #new" do
      get("/released_dbs/new").should route_to("released_dbs#new")
    end

    it "routes to #show" do
      get("/released_dbs/1").should route_to("released_dbs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/released_dbs/1/edit").should route_to("released_dbs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/released_dbs").should route_to("released_dbs#create")
    end

    it "routes to #update" do
      put("/released_dbs/1").should route_to("released_dbs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/released_dbs/1").should route_to("released_dbs#destroy", :id => "1")
    end

  end
end
