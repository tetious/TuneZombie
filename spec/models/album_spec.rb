require 'spec_helper'

describe Album do
  describe '.art_url' do
    it "should build based on album name" do
      album = FactoryGirl.build(:album, name: 'Tilverton Lives', art_type: 'jpg')
      album.art_url.should == '/.__TZAlbumArt__/Tilverton_Lives.jpg'
    end

    it "should generate a filesafe path" do
      album = FactoryGirl.build(:album, name: 'Tilverton:$#@% Lives', art_type: 'png')
      album.art_url.should == '/.__TZAlbumArt__/Tilverton_Lives.png'
    end

    it "should exclude extention if art_type is not provided" do
      album = FactoryGirl.build(:album, name: 'Tilverton Lives')
      album.art_url.should == '/.__TZAlbumArt__/Tilverton_Lives.'
    end
  end


end
