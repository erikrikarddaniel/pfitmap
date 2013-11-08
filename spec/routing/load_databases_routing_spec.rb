require "spec_helper"

describe LoadDatabasesController do
  let!(:sd) { FactoryGirl.create(:sequence_database) }
  describe "routing" do

    it "routes to #new" do
      get("/sequence_databases/#{sd.id}/load_databases/new").should route_to("load_databases#new", {sequence_database_id: sd.to_param})
    end

    it "routes to #show" do
      get("/sequence_databases/#{sd.id}/load_databases/1").should route_to("load_databases#show", {:id => "1", sequence_database_id: sd.to_param})
    end

    it "routes to #edit" do
      get("/sequence_databases/#{sd.id}/load_databases/1/edit").should route_to("load_databases#edit", {:id => "1", sequence_database_id: sd.to_param})
    end

    it "routes to #create" do
      post("/sequence_databases/#{sd.id}/load_databases").should route_to("load_databases#create", {sequence_database_id: sd.to_param})
    end

    it "routes to #update" do
      put("/sequence_databases/#{sd.id}/load_databases/1").should route_to("load_databases#update", {:id => "1", sequence_database_id: sd.to_param})
    end

    it "routes to #destroy" do
      delete("/sequence_databases/#{sd.id}/load_databases/1").should route_to("load_databases#destroy", {:id => "1", sequence_database_id: sd.to_param})
    end

  end
end
