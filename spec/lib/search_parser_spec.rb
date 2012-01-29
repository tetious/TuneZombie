require 'spec_helper'

describe SearchParser do

  before(:all) do
    @sp = SearchParser.new
  end

  describe '.where_for' do
    #it "should return where "

  end

  describe ".column_for" do
    it "should return :name for n" do
      @sp.column_for('al','n').should == :name
    end
  end

  describe '.get_class' do
    it "should return Album model for al" do
      @sp.model_for('al').should == Album
    end
  end

  describe ".table_name_for" do
    it "should return pluralized downcased model name" do
      @sp.table_name_for('al').should == 'albums'
    end
  end


end
