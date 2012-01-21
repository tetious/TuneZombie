require "spec_helper"
require "parser_helper"

files_path = "#{::Rails.root}/spec/files"

describe MusicLibrary do

  it "should start empty" do
    library = MusicLibrary.new
    library.library.should be_a(Hash)
    library.library.count.should be(0)
  end

  it "should have three item hash" do
    ml = MusicLibrary.new
    ml.load(files_path + "/timl.xml")
    ml.library.keys.count.should == 5
    ml.library.has_key?('01_black_sun.mp3~4642').should be_true
    track = ml.library['01_black_sun.mp3~4642']
    track[:name].should == 'Black Sun'
    track[:size].should == '438272'
  end

  it "should be able to parse a very large file" do
    #library = MusicLibrary.new
    #library.load(files_path + "/iml.xml")
    #library.library.keys.count.should == 30942

  end


end