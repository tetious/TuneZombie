require 'spec_helper'

describe "albums/index" do
  before(:each) do
    assign(:albums, [
      stub_model(Album),
      stub_model(Album)
    ])
  end

  it "renders a list of albums" do
    render
  end
end
