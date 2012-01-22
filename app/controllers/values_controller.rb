class ValuesController < ApplicationController
  respond_to :json
  
  def welcome
    render :text => "WELCOME"
  end
  
  # all values for that model, scenario, year and month (and variable)
  def mapval
    values = params[:variable] ? Value::Map.mapval_var(params) : Value::Map.mapval_all(params)
    respond_with(values)
  end
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  def mapvalaggr
    values = params[:variable] ? Value::Map.mapvalaggr_var(params) : Value::Map.mapvalaggr_all(params)
    respond_with(values)
  end
  
  # difference values for 2 specific months
  def mapdiff
    values = params[:variable] ? Value::Map.mapdiff_var(params) : Value::Map.mapdiff_all(params)
    respond_with(values)
  end
  
  # aggregated difference values for 2 specific years
  def mapdiffaggr
    values = params[:variable] ? Value::Map.mapdiffaggr_var(params) : Value::Map.mapdiffaggr_all(params)
    respond_with(values)
  end
  
  def propval
    values = Value::Prop.propval(params)
    respond_with(values) 
  end
  
  def propdiff
    values = params[:function1] ? Value::Prop.propdiffaggr(params) : Value::Prop.propdiff(params)
    respond_with(values) 
  end
  
end
