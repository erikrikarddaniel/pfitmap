require "spec_helper"

describe PfitmapReleasesController do
  describe "routing" do

    it "routes to #index" do
      get("/pfitmap_releases").should route_to("pfitmap_releases#index")
    end

    it "routes to #new" do
      get("/pfitmap_releases/new").should route_to("pfitmap_releases#new")
    end

    it "routes to #show" do
      get("/pfitmap_releases/1").should route_to("pfitmap_releases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pfitmap_releases/1/edit").should route_to("pfitmap_releases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pfitmap_releases").should route_to("pfitmap_releases#create")
    end

    it "routes to #update" do
      put("/pfitmap_releases/1").should route_to("pfitmap_releases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pfitmap_releases/1").should route_to("pfitmap_releases#destroy", :id => "1")
    end

  end
end
