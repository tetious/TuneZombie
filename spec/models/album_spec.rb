require 'spec_helper'

describe Album do
  describe '.art_url' do
    it "should build based on album id" do
      album = FactoryGirl.build(:album, id: 1, name: 'Tilverton Lives', art_type: 'jpg')
      album.art_url.should == '/Test/Path/.__TZAlbumArt__/1.jpg'
    end

    it "should return nil if art_type is not provided" do
      album = FactoryGirl.build(:album, id: 1, name: 'Tilverton Lives')
      album.art_url.should be_nil
    end
  end


end
