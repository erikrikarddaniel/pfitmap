require "spec_helper"

describe DbSequencesController do
  describe "routing" do

    it "routes to #index" do
      get("/db_sequences").should route_to("db_sequences#index")
    end

    it "routes to #new" do
      get("/db_sequences/new").should route_to("db_sequences#new")
    end

    it "routes to #show" do
      get("/db_sequences/1").should route_to("db_sequences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/db_sequences/1/edit").should route_to("db_sequences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/db_sequences").should route_to("db_sequences#create")
    end

    it "routes to #update" do
      put("/db_sequences/1").should route_to("db_sequences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/db_sequences/1").should route_to("db_sequences#destroy", :id => "1")
    end

  end
end
