require 'spec_helper'

describe Track do

  describe ".file_path" do
    it "should generate a path using album and artist" do
      artist = FactoryGirl.build(:artist, name: 'Bob Barker')
      album = FactoryGirl.build(:album, name: 'Tilverton Lives')
      track = FactoryGirl.build(:track, artist: artist, album: album)

      track.file_path.should == '/Test/Path/Bob_Barker/Tilverton_Lives/test.m4a'
    end

    it "should generate a path with a missing artist" do
      album = FactoryGirl.build(:album, name: 'Tilverton Lives')
      track = FactoryGirl.build(:track, album: album)
      track.file_path.should == '/Test/Path/__nil__/Tilverton_Lives/test.m4a'

    end

    it "should generate a path with a missing album" do
      artist = FactoryGirl.build(:artist, name: 'Bob Barker')
      track = FactoryGirl.build(:track, artist: artist)

      track.file_path.should == '/Test/Path/Bob_Barker/__nil__/test.m4a'
    end

    it "should generate a path with a missing album and artist" do
      track = FactoryGirl.build(:track)

      track.file_path.should == '/Test/Path/__nil__/__nil__/test.m4a'
    end

    it "should generate a filesafe path" do
      artist = FactoryGirl.build(:artist, name: 'Bob:$#@% Barker')
      album = FactoryGirl.build(:album, name: 'Tilverton:$#@% Lives')
      track = FactoryGirl.build(:track, artist: artist, album: album)

      track.file_path.should == '/Test/Path/Bob_Barker/Tilverton_Lives/test.m4a'
    end
  end


end
