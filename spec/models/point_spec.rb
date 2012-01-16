require 'spec_helper'

describe Point do
  
  before(:each) do
    @attr = {
      :x => 123,
      :y => 23.2
    }
  end
  
  it "should connect to MongoID and check fields" do
    Point.all.class.should == Mongoid::Criteria
    should have_fields(:x, :y)
  end
  
  it "should have many values" do
    should have_many(:values).with_foreign_key(:point_id)
  end
  
  it "should create a new instance given a valid attribute" do
    Point.all.count == 0
    Point.create!(@attr)
    Point.all.count == 1
  end
  
  it "should require x and y" do
    Point.new(@attr.merge(:x => "")).should_not be_valid
    should validate_presence_of(:x)
    should validate_presence_of(:y)
  end
  
  it "should reject duplicate x and y" do
    Point.create!(@attr)
    Point.new(@attr).should_not be_valid
  end

end
