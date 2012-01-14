Alarmproject::Application.routes.draw do
  
  root :to => 'values#welcome'
  
  # Routes for matrices
  
  # all values for that model, scenario, year and month (and variable)
  match 'mapval/:model/:scenario/:year/:month/all' => 'values#mapval', :month => /\d+/
  match 'mapval/:model/:scenario/:year/:month/:variable' => 'values#mapval', :month => /\d+/
  
  # all aggregated (min, max or avg) values for that model, scenario, year and 12 months (and variable)
  match 'mapval/:model/:scenario/:year/:function/all' => 'values#mapvalagr', :function => /min|max|avg/
  match 'mapval/:model/:scenario/:year/:function/:variable' => 'values#mapvalagr', :function => /min|max|avg/
  
  # difference values for 2 specific months
  match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/all' => 'values#mapdiff', :month1 => /\d+/, :month2 => /\d+/
  match 'mapdiff/:model/:scenario/:year1/:month1/:year2/:month2/:variable' => 'values#mapdiff', :month1 => /\d+/, :month2 => /\d+/
    
  # aggregated difference values for 2 specific years
  match 'mapdiff/:model/:scenario/:year1/:function1/:year2/:function2/all' => 'values#mapdiffagr', :function1 => /min|max|avg/, :function2 => /min|max|avg/
  match 'mapdiff/:model/:scenario/:year1/:function1/:year2/:function2/:variable' => 'values#mapdiffagr', :function1 => /min|max|avg/, :function2 => /min|max|avg/
  
  # Routes for properties
  
  # min|max|avg values for that model, scenario, year(s) and month(s) and variable
  match 'propval/:model/:scenario/:year/:month/:variable' => 'values#propval', :year => /\d+/, :month => /\d+/
  match 'propval/:model/:scenario/:year/all/:variable' => 'values#propval', :year => /\d+/
  match 'propval/:model/:scenario/all/all/:variable' => 'values#propval'
   
  # min|max|avg difference values for 2 specific years
  match 'propdiff/:model/:scenario/:year1/all/:year2/all/:variable' => 'values#propdiff'
  match 'propdiff/:model/:scenario/:year1/:function1/:year2/:function2/:variable' => 'values#propdiff', :function1 => /min|max|avg/, :function2 => /min|max|avg/
  
  # min|max|avg difference values for 2 specific months
  match 'propdiff/:model/:scenario/:year1/:month1/:year2/:month2/:variable' => 'values#propdiff', :month1 => /\d+/, :month2 => /\d+/
  
end
