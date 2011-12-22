class ValuesController < ApplicationController
  respond_to :json
  
  def welcome
    render :text => "WELCOME"
  end
  
  # all values for that model, scenario, year and month (and variable)
  def mapval
    values = params[:variable] ? Value.mapval_var(params) : Value.mapval_all(params)
    respond_with(values)
  end
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  def mapvalagr
    params[:model]
    params[:scenario]
    params[:year]
    params[:month]
    params[:function]
    if params[:variable]
      
    else
      
    end
  end
  
  # difference values for 2 specific months
  def mapdiff
    params[:model]
    params[:scenario]
    params[:year1]
    params[:month1]
    params[:year2]
    params[:month2]
    if params[:variable]
      
    else
      
    end
  end
  
  # aggregated difference values for 2 specific years
  def mapdiffagr
    params[:model]
    params[:scenario]
    params[:year1]
    params[:function1]
    params[:year2]
    params[:function2]
    if params[:variable]
      
    else
      
    end
  end
  
  
end

__END__

{
"map":"val",
"model_name":"Europe", "scenario_name":"BAMBU",
"year":2011, "month":11,
"data":{
"pre":[[null,null,...],[...,null,122.3,118.8,130.1,null,...],...],
"tmp":[[null,null,...],[...,null,8.2,8.3,7.4,null,...],...]
}
}

# all values for that model, scenario, year and month (and variable)
match 'mapval/:model/:scenario/:year/:month/(:variable)' => 'values#mapval' # , :variable => /tmp|pre/

# all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
match 'mapval/:model/:scenario/:year/:function/(:variable)' => 'values#mapvalagr', :function => /min|max|avg/

# difference values for 2 specific months
match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/(:variable)' => 'values#mapdiff'
  
# aggregated difference values for 2 specific years
match 'mapdiff/:model/:scenario/:year1/:function1/:year2/:function2/(:variable)' => 'values#mapdiffagr'
