class ValuesController < ApplicationController
  respond_to :json
  
  def welcome
    render :text => "WELCOME"
  end
  
  # all values for that model, scenario, year and month (and variable)
  def mapval
    values = params[:variable] ? Map.mapval_var(params) : Map.mapval_all(params)
    respond_with(values)
  end
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  def mapvalaggr
    values = params[:variable] ? Map.mapvalaggr_var(params) : Map.mapvalaggr_all(params)
    respond_with(values)
  end
  
  # difference values for 2 specific months
  def mapdiff
    values = params[:variable] ? Map.mapdiff_var(params) : Map.mapdiff_all(params)
    respond_with(values)
  end
  
  # aggregated difference values for 2 specific years
  def mapdiffaggr
    values = params[:variable] ? Map.mapdiffaggr_var(params) : Map.mapdiffaggr_all(params)
    respond_with(values)
  end
  
  def propval
    values = Prop.propval(params)
    respond_with(values) 
  end
  
  def propdiff
    values = params[:function1] ? Prop.propdiffaggr(params) : Prop.propdiff(params)
    respond_with(values) 
  end
  
end
