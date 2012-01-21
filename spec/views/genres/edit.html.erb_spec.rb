require 'spec_helper'

describe "genres/edit" do
  before(:each) do
    @genre = assign(:genre, stub_model(Genre))
  end

  it "renders the edit genre form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => genres_path(@genre), :method => "post" do
    end
  end
end
