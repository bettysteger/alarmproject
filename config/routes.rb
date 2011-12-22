Alarmproject::Application.routes.draw do
  
  root :to => 'values#welcome'
  # match ':controller(/:action(/:id(.:format)))'
  
  # all values for that model, scenario, year and month (and variable)
  match 'mapval/:model/:scenario/:year/:month/all' => 'values#mapval'
  match 'mapval/:model/:scenario/:year/:month/:variable' => 'values#mapval'
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  match 'mapval/:model/:scenario/:year/:function/(:variable)' => 'values#mapvalagr', :function => /min|max|avg/
  
  # difference values for 2 specific months
  match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/(:variable)' => 'values#mapdiff'
    
  # aggregated difference values for 2 specific years
  match 'mapdiff/:model/:scenario/:year1/:function1/:year2/:function2/(:variable)' => 'values#mapdiffagr', :function1 => /min|max|avg/, :function2 => /min|max|avg/
  
end
