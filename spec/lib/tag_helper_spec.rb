require "tag_helper"

files_path = "#{::Rails.root}/spec/files"
tmp_path = "#{::Rails.root}/tmp"

describe TagHelper do

  it "should save art file for m4a" do
    th = TagHelper.create(files_path + '/re_your_brains_png_m4a.m4a')
    tmp_art = tmp_path + '/re_brains_m4a'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should == tmp_path + '/re_brains_m4a.png'
    File.size(tmp_art).should be > 0

    #File.delete(tmp_art)
  end

  it "should save art file for mp3" do
    th = TagHelper.create(files_path + '/re_your_brains_png_mp3.mp3')
    tmp_art = tmp_path + '/re_brains_mp3'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should == tmp_path + '/re_brains_mp3.png'
    File.size(tmp_art).should be > 0

    #File.delete(tmp_art)
  end

  it "should not save art file if no art is attached, m4a" do
    th = TagHelper.create(files_path + '/re_your_brains_none_m4a.m4a')
    tmp_art = tmp_path + '/re_brains_n_m4a'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should be_nil
  end

  it "should not save art file if no art is attached, mp3" do
    th = TagHelper.create(files_path + '/re_your_brains_none_mp3.mp3')
    tmp_art = tmp_path + '/re_brains_n_mp3'
    tmp_art = th.save_art_to_path(tmp_art)
    tmp_art.should be_nil
  end


end