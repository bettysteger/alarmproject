require 'spec_helper'

describe Model do
  
  before(:each) do
    @attr = {
      :name => "Europe",
      :desc => "this is a description text for Europe"
    }
  end
  
  it "should connect to MongoID and check fields" do
    Model.all.class.should == Mongoid::Criteria
    should have_fields(:name, :desc)
  end
  
  it "should have many values" do
    should have_many(:values).with_foreign_key(:model_id)
  end
  
  it "should create a new instance given a valid attribute" do
    Model.all.count.should == 0
    Model.create!(@attr)
    Model.all.count.should == 1
  end
  
  it "should require a name" do
    Model.new(@attr.merge(:name => "")).should_not be_valid
    should validate_presence_of(:name)
  end
  
  it "should reject duplicate names" do
    Model.create!(@attr)
    Model.new(@attr).should_not be_valid
    should validate_uniqueness_of(:name)
  end

end
