require 'spec_helper'

describe "genres/index" do
  before(:each) do
    assign(:genres, [
      stub_model(Genre),
      stub_model(Genre)
    ])
  end

  it "renders a list of genres" do
    render
  end
end
