require 'spec_helper'

describe Value do
  
  describe "mongo db basics" do
    
    before(:each) do
      @attr = {
        :year => 2001,
        :month => 2,
        :number => 13.2,
        :model => Model.create!(:name => "Europe"),
        :scenario => Scenario.create!(:name => "BAMBU"),
        :variable => Variable.create!(:name => "pre"),
        :point => Point.create!(:x => 1, :y=> 2)
      }
    end
    
    it "should connect to MongoID and check fields" do
      Value.all.class.should == Mongoid::Criteria
      should have_fields(:year, :month, :number)
    end
    
    it "should belongs to the other models" do
      should belong_to(:model)
      should belong_to(:scenario)
      should belong_to(:variable)
      should belong_to(:point)
    end
    
    it "should create a new instance given a valid attribute" do
      Value.all.count.should == 0
      Value.create!(@attr)
      Value.all.count.should == 1
    end
    
    it "should require all attributes" do
      Value.new(@attr.merge(:number => "")).should_not be_valid
      should validate_presence_of(:year)
      should validate_presence_of(:month)
      should validate_presence_of(:number)
      should validate_presence_of(:model)
      should validate_presence_of(:scenario)
      should validate_presence_of(:variable)
      should validate_presence_of(:point)
    end

  end

end