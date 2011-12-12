require 'spec_helper'

describe Model do
  
  before(:each) do
    @attr = {
      :name => "Europe",
      :desc => "this is a description text for Europe"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    Model.create!(@attr)
  end
  
  it "should require a name" do
    Model.new(@attr.merge(:name => "")).should_not be_valid
  end
  
  it "should reject duplicate names" do
    Model.create!(@attr)
    Model.new(@attr).should_not be_valid
  end

end
