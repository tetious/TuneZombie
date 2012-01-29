require 'spec_helper'
#require 'search_parser'

class TestAlbum < ActiveRecord::Base
  searchable_as :tal
end

class TestTrack < ActiveRecord::Base

end

describe SearchParser do

  before(:all) do
    @sp = SearchParser.new [TestAlbum]
  end

  describe '.parse_tag' do

    #it "should expand alb name =" do
    #  tag = SearchParser.parse_tag('alb_name_gt')
    #  tag.should.start_with 'album.'
    #end

  end


  describe '.get_class' do
    it "should return TestAlbum model for al" do
      @sp.model_for('tal').should == TestAlbum
    end
  end

  describe ".table_name_for" do
    it "should return pluralized downcased model name" do
      @sp.table_name_for('tal').should == 'testalbums'
    end
  end


end
