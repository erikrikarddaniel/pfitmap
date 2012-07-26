require "spec_helper"

describe TaxonsController do
  describe "routing" do

    it "routes to #index" do
      get("/taxons").should route_to("taxons#index")
    end

    it "routes to #new" do
      get("/taxons/new").should route_to("taxons#new")
    end

    it "routes to #show" do
      get("/taxons/1").should route_to("taxons#show", :id => "1")
    end

    it "routes to #edit" do
      get("/taxons/1/edit").should route_to("taxons#edit", :id => "1")
    end

    it "routes to #create" do
      post("/taxons").should route_to("taxons#create")
    end

    it "routes to #update" do
      put("/taxons/1").should route_to("taxons#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/taxons/1").should route_to("taxons#destroy", :id => "1")
    end

  end
end
