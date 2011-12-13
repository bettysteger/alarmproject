require 'spec_helper'

describe Scenario do
  
  before(:each) do
    @attr = {
      :name => "BAMBU",
      :desc => "this is a description text for Europe"
    }
  end
  
  it "should connect to MongoID and check fields" do
    Scenario.all.class.should == Mongoid::Criteria
    should have_fields(:name, :desc)
  end
  
  it "should have many values" do
    should have_many(:values).with_foreign_key(:scenario_id)
  end
  
  it "should create a new instance given a valid attribute" do
    Scenario.all.count.should == 0
    Scenario.create!(@attr)
    Scenario.all.count.should == 1
  end
  
  it "should require a name" do
    Scenario.new(@attr.merge(:name => "")).should_not be_valid
    should validate_presence_of(:name)
  end
  
  it "should reject duplicate names" do
    Scenario.create!(@attr)
    Scenario.new(@attr).should_not be_valid
    should validate_uniqueness_of(:name)
  end

end
