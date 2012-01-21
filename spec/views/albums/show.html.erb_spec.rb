require 'spec_helper'

describe "albums/show" do
  before(:each) do
    @album = assign(:album, stub_model(Album))
  end

  it "renders attributes in <p>" do
    render
  end
end
