require 'spec_helper'

describe "tracks/new" do
  before(:each) do
    assign(:track, stub_model(Track).as_new_record)
  end

  it "renders new track form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tracks_path, :method => "post" do
    end
  end
end
