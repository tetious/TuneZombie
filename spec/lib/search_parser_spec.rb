require 'spec_helper'

describe SearchParser do
  before(:all) do
    @sp = SearchParser.new
  end

  it "should return Album model for al" do
    @sp.model('al').should == Album
  end

end


describe TableSearchParser do
  before(:all) do
    @sp = SearchParser.new.table('al')
  end

  describe '.where' do
    it "should return where (albums.name = 'foo') for n_eq/foo" do
      item = {'n_eq' => 'foo'}
      where = Album.where("albums.name = ?", 'foo')
      @sp.where(item).should == where
    end
  end

  describe ".column" do
    it "should return albums.name for n" do
      @sp.column('n').should == "albums.name"
    end
  end

  describe ".name" do
    it "should return pluralized downcased model name" do
      @sp.table_name.should == 'albums'
    end
  end

end
