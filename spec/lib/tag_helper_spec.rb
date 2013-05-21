#    This file is part of TuneZombie.
#    Copyright 2012 Greg Lincoln
#
#    TuneZombie is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    TuneZombie is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with TuneZombie.  If not, see <http://www.gnu.org/licenses/>.

require "tag_helper"
require 'spec_helper'

files_path = "#{::Rails.root}/spec/files"
tmp_path = "#{::Rails.root}/tmp"

describe TagHelper do

  describe "tags okay" do
    before(:all) do
      @tag_mp3 = TagHelper.create(files_path + '/re_your_brains_png_mp3.mp3')
      @tag_m4a = TagHelper.create(files_path + '/re_your_brains_png_m4a.m4a')
    end

    it "should parse artist name" do
      @tag_mp3.artist.should == "Test Artist"
      @tag_m4a.artist.should == "Test Artist"
    end

    it "should parse album name" do
      @tag_mp3.album.should == "Test Album"
      @tag_m4a.album.should == "Test Album"
    end

    it "should parse track name" do
      @tag_mp3.track.should == "re_your_brains_png_mp3"
      @tag_m4a.track.should == "re_your_brains_png_m4a"
    end

    it "should parse track number" do
      @tag_mp3.number.should == 5
      @tag_m4a.number.should == 5
    end

    it "should parse disc number" do
      @tag_mp3.disc.should == 5
      @tag_m4a.disc.should == 5
    end

    it "should parse composer" do
      @tag_mp3.composer.should == "Test Composer"
      @tag_m4a.composer.should == "Test Composer"
    end

    it "should parse genre" do
      @tag_mp3.genre.should == "Soundtrack"
      @tag_m4a.genre.should == "Soundtrack"
    end

    it "should parse length" do
      @tag_mp3.length.should == 12
      @tag_m4a.length.should == 12
    end

  end

  describe "tags missing" do
    before(:all) do
      @tag_mp3 = TagHelper.create(files_path + '/re_your_brains_none_mp3.mp3')
      @tag_m4a = TagHelper.create(files_path + '/re_your_brains_none_m4a.m4a')
    end

    it "should parse empty artist name" do
      @tag_mp3.artist.should be_nil
      @tag_m4a.artist.should be_nil
    end

    it "should parse empty album name" do
      @tag_mp3.album.should be_nil
      @tag_m4a.album.should be_nil
    end

    it "should parse empty track number" do
      @tag_mp3.number.should be_nil
      @tag_m4a.number.should be_nil
    end

    it "should parse empty disc number" do
      @tag_mp3.disc.should be_nil
      @tag_m4a.disc.should be_nil
    end

    it "should parse empty composer" do
      @tag_mp3.composer.should be_nil
      @tag_m4a.composer.should be_nil
    end

    it "should parse empty genre" do
      @tag_mp3.genre.should be_nil
      @tag_m4a.genre.should be_nil
    end

  end


  describe "art" do   
    it "should save art file for m4a" do
      th = TagHelper.create(files_path + '/re_your_brains_png_m4a.m4a')
      tmp_art = tmp_path + '/re_brains_m4a.png'
      th.save_art_to_path(tmp_art)
      File.size(tmp_art).should be > 0

      File.delete(tmp_art)
    end

    it "should save art file for mp3" do
      th = TagHelper.create(files_path + '/re_your_brains_png_mp3.mp3')
      tmp_art = tmp_path + '/re_brains_mp3.png'
      th.save_art_to_path(tmp_art)
      
      File.size(tmp_art).should be > 0

      File.delete(tmp_art)
    end

    it "should not save art file if no art is attached, m4a" do
      th = TagHelper.create(files_path + '/re_your_brains_none_m4a.m4a')
      tmp_art = tmp_path + '/re_brains_n_m4a.png'
      tmp_art = th.save_art_to_path(tmp_art)
      tmp_art.should be_nil
    end

    it "should not save art file if no art is attached, mp3" do
      th = TagHelper.create(files_path + '/re_your_brains_none_mp3.mp3')
      tmp_art = tmp_path + '/re_brains_n_mp3.png'
      tmp_art = th.save_art_to_path(tmp_art)
      tmp_art.should be_nil
    end
  end

end