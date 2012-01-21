require "spec_helper"
require "tag_helper"

files_path = "#{::Rails.root}/spec/files"
tmp_path = "#{::Rails.root}/tmp"

describe TagHelper do

  it "should save art file for m4a" do
    th = TagHelper.create(files_path + '/re_your_brains_png_m4a.m4a')
    tmp_art = tmp_path + '/re_brains'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should == tmp_path + '/re_brains.png'
    File.size(tmp_art).should be > 0

    File.delete(tmp_art)
  end

  it "should save art file for mp3" do
    th = TagHelper.create(files_path + '/re_your_brains_png_mp3.mp3')
    tmp_art = tmp_path + '/re_brains'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should == tmp_path + '/re_brains.png'
    File.size(tmp_art).should be > 0

    File.delete(tmp_art)
  end


end