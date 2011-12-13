require 'spec_helper'
require File.join(Rails.root + "lib/tasks/importer/importer")

describe Importer do
  
  before(:each) do
    @source = "spec/fixtures"
    @folder = File.join(Rails.root + @source)
    Dir.foreach(@folder) do |file|
      next if file == "." or file == ".."
      @importer = Importer.new(@folder, file)
      break;
    end
  end
  
  it "should initialize importer correctly" do
    all_importers = Array.new
    Dir.foreach(@folder) do |file|
      next if file == "." or file == ".."
      importer = Importer.new(@folder, file)
      all_importers << importer
    end
    
    all_importers.length.should == 6 # 6 fixture files
  end
  
  it "should execute importer correctly" do
    Model.all.count.should == 0
    Point.all.count.should == 0
    Scenario.all.count.should == 0
    Value.all.count.should == 0
    Variable.all.count.should == 0
    
    @importer.execute
    Model.all.count.should == 1
    Model.first.name.should == "Europe" # default in initializer
    Scenario.all.count.should == 1
    Scenario.first.name.should == "BAMBU" # first name from fixture-filename
    Variable.all.count.should == 1
    Variable.first.name.should == "pre" # fixture-file extension
  end
  
  it "should execute importer correctly, details" do
    Model.all.count.should == 0
    Point.all.count.should == 0
    Scenario.all.count.should == 0
    Value.all.count.should == 0
    Variable.all.count.should == 0
    
    @importer.execute
    # Point.all.count.should  == 2    # fixture value
    # Point.first.x.should    == 4    # fixture value
    # Point.first.y.should    == 109  # fixture value
    # Point.last.x.should     == 5    # fixture value
    # Point.last.y.should     == 108  # fixture value
    # 
    # Value.all.count.should == 72
    # value = Value.first
    # value.year.should           == 2001
    # value.month.should          == 1
    # value.number.should          == 191.0
    # value.model.name.should     == "Europe"
    # value.scenario.name.should  == "BAMBU"
    # value.variable.name.should  == "pre"
    # value.point.x.should        == 4
    # value.point.y.should        == 109
  end
   
end