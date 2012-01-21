require "spec_helper"

describe TracksController do
  describe "routing" do

    it "routes to #index" do
      get("/tracks").should route_to("tracks#index")
    end

    it "routes to #new" do
      get("/tracks/new").should route_to("tracks#new")
    end

    it "routes to #show" do
      get("/tracks/1").should route_to("tracks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tracks/1/edit").should route_to("tracks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tracks").should route_to("tracks#create")
    end

    it "routes to #update" do
      put("/tracks/1").should route_to("tracks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tracks/1").should route_to("tracks#destroy", :id => "1")
    end

  end
end
