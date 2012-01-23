class Value::Prop < Value
  
  # properties methods
  
  def self.propval params
    result = Value.collection.map_reduce(map, reduce, finalize: finalize, out: "results", query: get_query(params))
    result = result.find().first["value"]
    
    data = {}
    data[params[:variable]] = {}
    data[params[:variable]]["min"] = result["min"]
    data[params[:variable]]["max"] = result["max"]
    data[params[:variable]]["avg"] = result["avg"]

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
  
  
  private
  
  def self.map
    "function() {emit(this.scenario_id, this.number);}"
  end
  
  def self.reduce
    "function(point, values) {
      var n = {min: 0, max: 0, avg: 0, sum: 0, count: 0};
      var min = values[0];
      var max = values[0];
      values.forEach(function(number) {
        if (number < min) min = number;
        if (number > max) max = number;
        n.sum += number;
      });
      n.min = min;
      n.max = max;
      n.count = values.length;
      return n;
    }"
  end
  
  def self.finalize
    "function (point, value) {
      value.avg = value.sum / value.count;
      delete value.sum;
      delete value.count;
      return value;
    }"
  end

end