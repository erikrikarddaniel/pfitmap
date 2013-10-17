require "spec_helper"
# ========================================================================
# !!!!!TODO Note that this test was generated for table named HmmDBHit but
# has been altered since that table will be renamed to DBEntry.
# Go over the test and change references to HmmDBHit when renaming is done
# ========================================================================

describe DbEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/db_entries").should route_to("db_entries#index")
    end

    it "routes to #new" do
      get("/db_entries/new").should route_to("db_entries#new")
    end

    it "routes to #show" do
      get("/db_entries/1").should route_to("db_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/db_entries/1/edit").should route_to("db_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/db_entries").should route_to("db_entries#create")
    end

    it "routes to #update" do
      put("/db_entries/1").should route_to("db_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/db_entries/1").should route_to("db_entries#destroy", :id => "1")
    end

  end
end
