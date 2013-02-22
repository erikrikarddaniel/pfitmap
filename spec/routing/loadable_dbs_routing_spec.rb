require "spec_helper"

describe LoadableDbsController do
  describe "routing" do

    it "routes to #index" do
      get("/loadable_dbs").should route_to("loadable_dbs#index")
    end

    it "routes to #new" do
      get("/loadable_dbs/new").should route_to("loadable_dbs#new")
    end

    it "routes to #show" do
      get("/loadable_dbs/1").should route_to("loadable_dbs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/loadable_dbs/1/edit").should route_to("loadable_dbs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/loadable_dbs").should route_to("loadable_dbs#create")
    end

    it "routes to #update" do
      put("/loadable_dbs/1").should route_to("loadable_dbs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/loadable_dbs/1").should route_to("loadable_dbs#destroy", :id => "1")
    end

  end
end
