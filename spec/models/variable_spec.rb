require 'spec_helper'

describe Variable do
  
  before(:each) do
    @attr = {
      :name => "pre",
      :desc => "this is a description text for precipitation "
    }
  end
  
  it "should connect to MongoID and check fields" do
    Variable.all.class.should == Mongoid::Criteria
    should have_fields(:name, :desc)
  end
  
  it "should have many values" do
    should have_many(:values).with_foreign_key(:variable_id)
  end
  
  it "should create a new instance given a valid attribute" do
    Variable.all.count.should == 0
    Variable.create!(@attr)
    Variable.all.count.should == 1
  end
  
  it "should require a name" do
    Variable.new(@attr.merge(:name => "")).should_not be_valid
    should validate_presence_of(:name)
  end
  
  it "should reject duplicate names" do
    Variable.create!(@attr)
    Variable.new(@attr).should_not be_valid
    should validate_uniqueness_of(:name)
  end

end
