require 'spec_helper'

describe "tracks/index" do
  before(:each) do
    assign(:tracks, [
      stub_model(Track),
      stub_model(Track)
    ])
  end

  it "renders a list of tracks" do
    render
  end
end
