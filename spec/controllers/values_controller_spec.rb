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
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", month: "1",
        data: { pre: [1.0, 4.0]}
      }.to_json
      
      get :mapval, model: "Europe", scenario: "BAMBU", year: 2001, month: 1, variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapval_all" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", month: "1",
        data: { pre: [1.0, 4.0], tmp: [7.0, 10.0] }
      }.to_json
      
      get :mapval, model: "Europe", scenario: "BAMBU", year: 2001, month: 1, format: :json
      response.body.should == expected
    end

  end
  
  describe "mapvalagr" do
    
    it "should render right result: mapvalagr_var min" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "min",
        data: { pre: [1.0, 4.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "min", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_var max" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "max",
        data: { pre: [3.0, 6.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "max", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_var avg" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "avg",
        data: { pre: [2.0, 5.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "avg", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_all min" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "min",
        data: { pre: [1.0, 4.0], tmp: [7.0, 10.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "min", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_all max" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "max",
        data: { pre: [3.0, 6.0], tmp: [9.0, 12.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "max", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_all avg" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", function: "avg",
        data: { pre: [2.0, 5.0], tmp: [8.0, 11.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "avg", format: :json
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
  
  describe "mapdiffagr" do
  
    it "should render right result: mapdiffagr_var" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", function1: "max", year2: "2001", function2: "min",
        data: { pre: [2.0, 2.0] }
      }.to_json

      get :mapdiffagr, model: "Europe", scenario: "BAMBU", year1: 2001, function1: "max", year2: 2001, function2: "min", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapdiffagr_all" do
      expected = {
        map: "diff", model_name: "Europe", scenario_name: "BAMBU", year1: "2001", function1: "max", year2: "2001", function2: "avg",
        data: { pre: [1.0, 1.0], tmp: [1.0, 1.0] }
      }.to_json

      get :mapdiffagr, model: "Europe", scenario: "BAMBU", year1: 2001, function1: "max", year2: 2001, function2: "avg", format: :json
      response.body.should == expected
    end
    
  end

  
  private
    include SpecHelperMethods
  
end