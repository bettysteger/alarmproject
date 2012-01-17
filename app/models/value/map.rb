class Map < Value
  
  # matrices methods
  
  def self.mapval_var params
    values = get_values(params)
    data = {}
    data[params[:variable]] = values.map(&:number)
    output_hash("val", params, data)
  end
  
  def self.mapval_all params
    data = {}
    Variable.all.each do |var|
      values = get_values(params, var.id)
      data[var.name] = values.map(&:number)
    end
    output_hash("val", params, data)
  end
  
  def self.mapvalaggr_var params
    
    model_id = Model.find_id_by_name(params[:model])
    scenario_id = Scenario.find_id_by_name(params[:scenario])
    var_id = Variable.find_id_by_name(params[:variable]) if params[:variable]
    
    year = params[:year].to_i
    query = {model_id: model_id, scenario_id: scenario_id, variable_id: var_id, year: year.to_i}
    
    # reduce = "function(point, values) {
    #   var n = {avg: 0, min: 0, max: 0};
    #   var sum = 0;
    #   var count = 0;
    #   var min = values[0];
    #   var max = values[0];
    #   values.forEach(function(number) {
    #     if (number < min) min = number;
    #     if (number > max) max = number;
    #     sum += number;
    #     count += 1;
    #   });
    #   n.min = min;
    #   n.max = max;
    #   n.avg = sum / count;
    #   return n;
    # }"
    # finalize = "function (point, value) {
    #   value.avg = value.sum / value.count;
    #   delete value.sum;
    #   delete value.count;
    #   return value;
    # }"
    
    data = {}
    data[params[:variable]] = []
    
    result = Value.collection.map_reduce(map, send("reduce_#{params[:function]}"), out: "results", query: query)
    result.find().each do |hash|
      data[params[:variable]] << hash["value"]
    end

    output_hash("val", params, data)
  end
  
  def self.mapvalaggr_all params
    data = {}
    Variable.all.each do |var|
      data[var.name] = []
      values = get_values(params, var.id)
      hash = values.asc(:number).group_by(&:point_id)
      hash.each do |k,v|
        data[var.name] << get_aggr(params[:function], v)
      end
    end
    output_hash("val", params, data)
  end
  
  def self.mapdiff_var params
    data = {}
    data[params[:variable]] = []
    
    values1 = get_values(params, false, 1)
    hash1 = values1.group_by(&:point_id)
    
    values2 = get_values(params, false, 2)
    hash2 = values2.group_by(&:point_id)
    
    hash1.each do |key1,values1|
      hash2.each do |key2, values2|
        if key1 == key2
          values1.each_with_index do |val1, index|
            data[params[:variable]] << val1.number - values2[index].number
          end
        end
      end
    end
    output_hash("diff", params, data)
  end

  def self.mapdiff_all params
    data = {}

    Variable.all.each do |var|
      data[var.name] = []
      values1 = get_values(params, var.id, 1)
      hash1 = values1.group_by(&:point_id)
      
      values2 = get_values(params, var.id, 2)
      hash2 = values2.group_by(&:point_id)
    
      hash1.each do |key1,values1|
        hash2.each do |key2, values2|
          if key1 == key2
            values1.each_with_index do |val1, index|
              data[var.name] << val1.number - values2[index].number
            end
          end
        end
      end
    end
    output_hash("diff", params, data)
  end
  
  def self.mapdiffaggr_var params
    data = {}
    data[params[:variable]] = []
    
    values1 = get_values(params, false, 1)
    hash1 = values1.asc(:number).group_by(&:point_id)
    
    values2 = get_values(params, false, 2)
    hash2 = values2.asc(:number).group_by(&:point_id)

    hash1.each do |key1,values1|
      hash2.each do |key2, values2|
        if key1 == key2
          number1 = get_aggr(params[:function1], values1)
          number2 = get_aggr(params[:function2], values2)
          data[params[:variable]] << number1 - number2
        end
      end
    end
    output_hash("diff", params, data)
  end

  def self.mapdiffaggr_all params
    data = {}

    Variable.all.each do |var|
      data[var.name] = []
      
      values1 = get_values(params, var.id, 1)
      hash1 = values1.asc(:number).group_by(&:point_id)
    
      values2 = get_values(params, var.id, 2)
      hash2 = values2.asc(:number).group_by(&:point_id)
      
      hash1.each do |key1,values1|
        hash2.each do |key2, values2|
          if key1 == key2
            number1 = get_aggr(params[:function1], values1)
            number2 = get_aggr(params[:function2], values2)
            data[var.name] << number1 - number2
          end
        end
      end
    end
    output_hash("diff", params, data)
  end


end