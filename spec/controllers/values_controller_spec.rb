require 'spec_helper'
require File.join(Rails.root + "spec/spec_helper_methods")

describe ValuesController do
  
  describe "mapval" do

    before(:each) do
      create_dummy_data
    end
    
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

    before(:each) do
      create_dummy_data
    end
    
    it "should render right result: mapvalagr_var min" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", month: nil,
        data: { pre: [1.0, 4.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "min", variable: "pre", format: :json
      response.body.should == expected
    end
    
    it "should render right result: mapvalagr_var max" do
      expected = {
        map: "val", model_name: "Europe", scenario_name: "BAMBU", year: "2001", month: nil,
        data: { pre: [3.0, 6.0] }
      }.to_json

      get :mapvalagr, model: "Europe", scenario: "BAMBU", year: 2001, function: "max", variable: "pre", format: :json
      response.body.should == expected
    end

  end
  
  describe "mapdiff" do
    
  end
  
  describe "mapdiffaggr" do
    
  end
  
  private
    include SpecHelperMethods
  
end