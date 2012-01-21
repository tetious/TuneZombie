require 'spec_helper'

describe "albums/new" do
  before(:each) do
    assign(:album, stub_model(Album).as_new_record)
  end

  it "renders new album form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => albums_path, :method => "post" do
    end
  end
end
