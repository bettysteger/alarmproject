require 'spec_helper'
require File.join(Rails.root + "lib/tasks/importer/importer")
require File.join(Rails.root + "spec/spec_helper_methods")

describe Importer do
  
   # Please note:
   # You can find all the "magic numbers" in the fixture files!
   # The fixture files for these tests are under @folder + @source
   # from the before(:each) block below:
  
  before(:each) do
    @source = "spec/fixtures"
    @folder = File.join(Rails.root + @source)
  end
  
  it "should initialize importer correctly" do
    all_importers = Array.new
    Dir[@folder + "/*.*"].each do |file|
      next if file == "." or file == ".."
      importer = Importer.new(@folder, file)
      all_importers << importer
    end
    
    all_importers.length.should == 9 # 9 fixture files
  end
  
  it "should prepare the mongo db correctly" do
    nothing_in_db
    
    Dir[@folder + "/*.*"].each do |file|
       next if file == "." or file == ".."
       importer = Importer.new(@folder, file)
       importer.prepare
    end

    Model.all.count.should == 1
    Model.first.name.should == "Europe" # default in initializer

    Scenario.all.count.should == 3        # BAMBU, GRAS, SEDG (fixtures)
    Scenario.where(name: "BAMBU").count == 1
    Scenario.where(name: "GRAS").count == 1
    Scenario.where(name: "SEDG").count == 1
    
    Variable.all.count.should == 3         # gdd, pre, tmp (fixtures)
    Variable.where(name: "gdd").count == 1
    Variable.where(name: "pre").count == 1
    Variable.where(name: "tmp").count == 1
  end

  it "should write json files correctly" do
    nothing_in_db
    
    importer = Importer.new(@folder, "#{@folder}/BAMBU.gdd")
    importer.prepare
    
    json_directory = "#{@folder}/json"
    File.directory?(json_directory).should == false
    
    importer.execute
    File.directory?(json_directory).should == true
    File.exists?(json_directory + "/BAMBU.gdd.1points.json").should == true
    File.exists?(json_directory + "/BAMBU.gdd.1values.json").should == true
    
    delete_json_directory
  end
  
  it "should import data from json files correctly" do
    nothing_in_db
    
    importer = Importer.new(@folder, "#{@folder}/BAMBU.gdd")
    importer.prepare
    importer.execute
    
    json_directory = "#{@folder}/json"
    
    `mongoimport -d #{db_name} -c points "#{json_directory}/BAMBU.gdd.1points.json"`
    `mongoimport -d #{db_name} -c values "#{json_directory}/BAMBU.gdd.1values.json"`
    
    Model.all.count.should == 1
    Model.first.name.should == "Europe"

    Scenario.all.count.should == 1
    Scenario.where(name: "BAMBU").count == 1
    
    Variable.all.count.should == 1
    Variable.where(name: "gdd").count == 1
   
    Point.all.count.should == 2
    Point.first.x.should == 4
    Point.first.y.should == 109
    Point.last.x.should == 5
    Point.last.y.should == 108
    Point.first.values.count.should == 36
    Point.last.values.count.should == 36
    
    Value.all.count.should == 72
    value = Value.first
    value.year.should == 2001
    value.month.should == 1
    value.number.should == 53
    value.model.name.should == "Europe"
    value.scenario.name.should == "BAMBU"
    value.variable.name.should == "gdd"
    value.point.x.should == 4
    value.point.y.should == 109
    
    delete_json_directory
  end
  
  private
  
      include SpecHelperMethods
   
end