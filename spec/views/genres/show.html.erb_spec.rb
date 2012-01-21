require 'spec_helper'

describe "genres/show" do
  before(:each) do
    @genre = assign(:genre, stub_model(Genre))
  end

  it "renders attributes in <p>" do
    render
  end
end
