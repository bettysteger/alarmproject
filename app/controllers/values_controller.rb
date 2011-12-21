class ValuesController < ApplicationController
  
  def welcome
    render :text => "WELCOME"
  end
  
  def mapval
    raise params.inspect
    params[:model]
    params[:scenario]
    params[:year]
    params[:month]
  end
  
  def mapdiff
    
  end
  
  
end

__END__
  
  # all values for that model, scenario, year and month (and variable)
  match 'mapval/:model/:scenario/:year/:month/' => 'values#mapval'
  match 'mapval/:model/:scenario/:year/:month/tmp|pre' => 'values#mapval'
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  match 'mapval/:model/:scenario/:year/min|max|avg/' => 'values#mapval'
  match 'mapval/:model/:scenario/:year/min|max|avg/tmp|pre' => 'values#mapval'
  
  # difference values for 2 specific years
  match 'mapdiff/:model/:scenario/:year1/min|max|avg/:year2/min|max|avg/' => 'values#mapdiff'
  match 'mapdiff/:model/:scenario/:year1/min|max|avg/:year2/min|max|avg/tmp|pre' => 'values#mapdiff'
  
  match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/' => 'values#mapdiff'
  match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/tmp|pre' => 'values#mapdiff'