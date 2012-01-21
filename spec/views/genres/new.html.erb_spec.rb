require 'spec_helper'

describe "genres/new" do
  before(:each) do
    assign(:genre, stub_model(Genre).as_new_record)
  end

  it "renders new genre form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => genres_path, :method => "post" do
    end
  end
end
