require 'spec_helper'
require File.join(Rails.root + "spec/spec_helper_methods")

describe ValuesController do

  # Please note:
  # You can find all the "magic numbers" in spec/spec_helper_methods
  # in the create data methods
  
  before(:each) do
    create_dummy_data
  end
  
  describe "mapval" do

    it "should render right result: mapval_var" do
      get :mapval, model: "Europe", scenario: "BAMBU", year: 2001, month: 1, variable: "pre", format: :json
      assert1 = response.body.match /\{"map":"val","model_name":"Europe","scenario_name":"BAMBU","year":"2001","month":"1","data":\{"pre":/
      assert1.should be_true
      assert2 = response.body.match "#{/.*/}1.0#{/.*/}4.0#{/.*/}"
      assert2.should be_true
      assert3 = response.body.match "#{/.*/}7.0#{/.*/}10.0#{/.*/}"
      assert3.should be_false
    end

    it "should render right result: mapval_all" do
      get :mapval, model: "Europe", scenario: "BAMBU", year: 2001, month: 1, format: :json
      assert1 = response.body.match /\{"map":"val","model_name":"Europe","scenario_name":"BAMBU","year":"2001","month":"1","data":\{"pre":/
      assert1.should be_true
      assert2 = response.body.match "#{/.*/}1.0#{/.*/}4.0#{/.*/}7.0#{/.*/}10.0#{/.*/}"
      assert2.should be_true
    end

  end
  
  describe "mapvalaggr" do
    
    it "should render right result: mapvalaggr_var min" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "min",
        data: { pre: [1.0, 4.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "min", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalaggr_var max" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "max",
        data: { pre: [3.0, 6.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "max", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalaggr_var avg" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "avg",
        data: { pre: [2.0, 5.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "avg", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalaggr_all min" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "min",
        data: { pre: [1.0, 4.0], tmp: [7.0, 10.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "min", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalaggr_all max" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "max",
        data: { pre: [3.0, 6.0], tmp: [9.0, 12.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "max", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalaggr_all avg" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "avg",
        data: { pre: [2.0, 5.0], tmp: [8.0, 11.0] }
      }.to_json

      get :mapvalaggr, model: "Europe", scenario: "BAMBU", year: 2001, function: "avg", format: :json
      response.body.should == expected
    end

  end
  
  describe "mapdiff" do
    
    it "should render right result: mapdiff_var" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", month1: "1", year2: "2001", month2: "2",
        data: { pre: [-1.0, -1.0] }
      }.to_json

      get :mapdiff, model: "Europe", scenario: "BAMBU", year1: 2001, month1: 1, year2: 2001, month2: 2, variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapdiff_all" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", month1: "1", year2: "2001", month2: "2",
        data: { pre: [-1.0, -1.0], tmp: [-1.0, -1.0] }
      }.to_json

      get :mapdiff, model: "Europe", scenario: "BAMBU", year1: 2001, month1: 1, year2: 2001, month2: 2, format: :json
      response.body.should == expected
    end
  
  end
  
  describe "mapdiffaggr" do
  
    it "should render right result: mapdiffaggr_var" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", function1: "max", year2: "2001", function2: "min",
        data: { pre: [2.0, 2.0] }
      }.to_json

      get :mapdiffaggr, model: "Europe", scenario: "BAMBU", year1: 2001, function1: "max", year2: 2001, function2: "min", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapdiffaggr_all" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", function1: "max", year2: "2001", function2: "avg",
        data: { pre: [1.0, 1.0], tmp: [1.0, 1.0] }
      }.to_json

      get :mapdiffaggr, model: "Europe", scenario: "BAMBU", year1: 2001, function1: "max", year2: 2001, function2: "avg", format: :json
      response.body.should == expected
    end
    
  end
  
  describe "propval" do
    
    it "should render right result: propval month variable" do
      expected = {
        prop: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", month: "1",
        data: { pre: { min: 1.0, max: 4.0, avg: 2.5 } }
      }.to_json

      get :propval, model: "Europe", scenario: "BAMBU", year: 2001, month: 1, variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: propval month all" do
      expected = {
        prop: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001",
        data: { pre: { min: 1.0, max: 6.0, avg: 3.5 } }
      }.to_json

      get :propval, model: "Europe", scenario: "BAMBU", year: 2001, variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: propval month all year all" do
      expected = {
        prop: "val", model_name: "Europe", scenario_name: "BAMBU",
        data: { pre: { min: 1.0, max: 26.0, avg: 9.777777777777779 } }
      }.to_json

      get :propval, model: "Europe", scenario: "BAMBU", variable: "pre", format: :json
      response.body.should == expected
    end
  end
  
  describe "propdiff" do
    
    it "should render right result: propdiff only year" do
      expected = {
        prop: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", year2: "2002",
        data: { pre: { min: -14.0, max: -9.0, avg: -11.5 } }
      }.to_json

      get :propdiff, model: "Europe", scenario: "BAMBU", year1: 2001, year2: 2002, variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: propdiffaggr year function" do
      expected = {
        prop: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", function1: "min", year2: "2002", function2: "max",
        data: { diff: -14.0 }
      }.to_json

      get :propdiff, model: "Europe", scenario: "BAMBU", year1: 2001, function1: "min", year2: 2002, function2: "max", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: propdiff year month" do
      expected = {
        prop: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", month1: "1", year2: "2004", month2: "1",
        data: { pre: { min: -25.0, max: -22.0, avg: -23.5} }
      }.to_json

      get :propdiff, model: "Europe", scenario: "BAMBU", year1: 2001, month1: 1, year2: 2004, month2: 1, variable: "pre", format: :json
      response.body.should == expected
    end
  end

  private
    include SpecHelperMethods
  
end