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
    values = get_values(params)
    hash = values.asc(:number).group_by(&:point_id)
    
    data = {}
    data[params[:variable]] = []
    
    hash.each do |k,v|
      data[params[:variable]] << get_aggr(params[:function], v)
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