require "spec_helper"

describe LoadDatabasesController do
  describe "routing" do

    it "routes to #index" do
      get("/load_databases").should route_to("load_databases#index")
    end

    it "routes to #new" do
      get("/load_databases/new").should route_to("load_databases#new")
    end

    it "routes to #show" do
      get("/load_databases/1").should route_to("load_databases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/load_databases/1/edit").should route_to("load_databases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/load_databases").should route_to("load_databases#create")
    end

    it "routes to #update" do
      put("/load_databases/1").should route_to("load_databases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/load_databases/1").should route_to("load_databases#destroy", :id => "1")
    end

  end
end
