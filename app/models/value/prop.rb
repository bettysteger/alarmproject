class Prop < Value
  
  # properties methods
  
  def self.propval params
    values = get_values(params).asc(:number)
    data = {}
    data[params[:variable]] = {}
    data[params[:variable]]["min"] = values.first.number
    data[params[:variable]]["max"] = values.last.number
    data[params[:variable]]["avg"] = avg(values)

    output_hash("val", params, data, "prop")
  end
  
  def self.propdiff params
    values1 = get_values(params, false, 1).asc(:number)
    values2 = get_values(params, false, 2).asc(:number)
    
    data = {}
    data[params[:variable]] = {}
    data[params[:variable]]["min"] = values1.first.number - values2.first.number
    data[params[:variable]]["max"] = values1.last.number - values2.last.number
    data[params[:variable]]["avg"] = avg(values1) - avg(values2)

    output_hash("diff", params, data, "prop")
  end
  
  def self.propdiffaggr params
    values1 = get_values(params, false, 1).asc(:number)
    values2 = get_values(params, false, 2).asc(:number)

    data = {}
    number1 = get_aggr(params[:function1], values1)
    number2 = get_aggr(params[:function2], values2)
    data["diff"] = number1 - number2

    output_hash("diff", params, data, "prop")
  end

end