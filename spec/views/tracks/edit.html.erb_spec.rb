require 'spec_helper'

describe "tracks/edit" do
  before(:each) do
    @track = assign(:track, stub_model(Track))
  end

  it "renders the edit track form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tracks_path(@track), :method => "post" do
    end
  end
end
