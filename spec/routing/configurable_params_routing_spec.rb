require "spec_helper"

describe ConfigurableParamsController do
  describe "routing" do

    it "routes to #index" do
      get("/configurable_params").should route_to("configurable_params#index")
    end

    it "routes to #new" do
      get("/configurable_params/new").should route_to("configurable_params#new")
    end

    it "routes to #show" do
      get("/configurable_params/1").should route_to("configurable_params#show", :id => "1")
    end

    it "routes to #edit" do
      get("/configurable_params/1/edit").should route_to("configurable_params#edit", :id => "1")
    end

    it "routes to #create" do
      post("/configurable_params").should route_to("configurable_params#create")
    end

    it "routes to #update" do
      put("/configurable_params/1").should route_to("configurable_params#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/configurable_params/1").should route_to("configurable_params#destroy", :id => "1")
    end

  end
end
