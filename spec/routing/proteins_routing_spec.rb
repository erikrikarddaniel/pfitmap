require "spec_helper"

describe ProteinsController do
  describe "routing" do

    it "routes to #index" do
      get("/proteins").should route_to("proteins#index")
    end

    it "routes to #new" do
      get("/proteins/new").should route_to("proteins#new")
    end

    it "routes to #show" do
      get("/proteins/1").should route_to("proteins#show", :id => "1")
    end

    it "routes to #edit" do
      get("/proteins/1/edit").should route_to("proteins#edit", :id => "1")
    end

    it "routes to #create" do
      post("/proteins").should route_to("proteins#create")
    end

    it "routes to #update" do
      put("/proteins/1").should route_to("proteins#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/proteins/1").should route_to("proteins#destroy", :id => "1")
    end

  end
end
