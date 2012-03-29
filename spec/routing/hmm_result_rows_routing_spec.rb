require "spec_helper"

describe HmmResultRowsController do
  describe "routing" do

    it "routes to #index" do
      get("/hmm_result_rows").should route_to("hmm_result_rows#index")
    end

    it "routes to #new" do
      get("/hmm_result_rows/new").should route_to("hmm_result_rows#new")
    end

    it "routes to #show" do
      get("/hmm_result_rows/1").should route_to("hmm_result_rows#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hmm_result_rows/1/edit").should route_to("hmm_result_rows#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hmm_result_rows").should route_to("hmm_result_rows#create")
    end

    it "routes to #update" do
      put("/hmm_result_rows/1").should route_to("hmm_result_rows#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hmm_result_rows/1").should route_to("hmm_result_rows#destroy", :id => "1")
    end

  end
end
