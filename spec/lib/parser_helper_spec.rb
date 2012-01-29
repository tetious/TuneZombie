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

require "parser_helper"
require 'spec_helper'

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