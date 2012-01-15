class Value
  include Mongoid::Document
  include Mongoid::MapReduce

  field :year,    type: Integer
  field :month,   type: Integer
  field :number,  type: Float

  validates :year,      presence: true
  validates :month,     presence: true
  validates :number,    presence: true
  validates :model,     presence: true
  validates :scenario,  presence: true
  validates :variable,  presence: true
  validates :point,     presence: true
  
  belongs_to :model, index: true
  belongs_to :scenario, index: true
  belongs_to :variable, index: true
  belongs_to :point, index: true
  
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
  
  def self.mapvalagr_var params
    values = get_values(params)
    hash = values.asc(:number).group_by(&:point_id)
    
    data = {}
    data[params[:variable]] = []
    
    hash.each do |k,v|
      data[params[:variable]] << v.first.number if params[:function] == "min"
      data[params[:variable]] << v.last.number if params[:function] == "max"
      data[params[:variable]] << v.collect(&:number).sum.to_f/v.length if params[:function] == "avg"
    end
    output_hash("val", params, data)
  end
  
  def self.mapvalagr_all params
    data = {}
    Variable.all.each do |var|
      data[var.name] = []
      values = get_values(params, var.id)
      hash = values.asc(:number).group_by(&:point_id)
      hash.each do |k,v|
        data[var.name] << v.first.number if params[:function] == "min"
        data[var.name] << v.last.number if params[:function] == "max"
        data[var.name] << v.collect(&:number).sum.to_f/v.length if params[:function] == "avg"
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
  
  def self.mapdiffagr_var params
    function1 = params[:function1]
    function2 = params[:function2]

    data = {}
    data[params[:variable]] = []
    
    values1 = get_values(params, false, 1)
    hash1 = values1.asc(:number).group_by(&:point_id)
    
    values2 = get_values(params, false, 2)
    hash2 = values2.asc(:number).group_by(&:point_id)

    hash1.each do |key1,values1|
      hash2.each do |key2, values2|
        if key1 == key2
          case function1
            when "min"
              number1 = values1.first.number
            when "max"
              number1 = values1.last.number
            when "avg"
              number1 = values1.collect(&:number).sum.to_f/values1.length
          end
          case function2
            when "min"
              number2 = values2.first.number
            when "max"
              number2 = values2.last.number
            when "avg"
              number2 = values2.collect(&:number).sum.to_f/values2.length
          end
          data[params[:variable]] << number1 - number2
        end
      end
    end
    output_hash("diff", params, data)
  end

  def self.mapdiffagr_all params
    function1 = params[:function1]
    function2 = params[:function2]
    
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
            case function1
              when "min"
                number1 = values1.first.number
              when "max"
                number1 = values1.last.number
              when "avg"
                number1 = values1.collect(&:number).sum.to_f/values1.length
            end
            case function2
              when "min"
                number2 = values2.first.number
              when "max"
                number2 = values2.last.number
              when "avg"
                number2 = values2.collect(&:number).sum.to_f/values2.length
            end
            data[var.name] << number1 - number2
          end
        end
      end
    end
    output_hash("diff", params, data)
  end
  
  # properties methods
  
  def self.propval params
    
    # without group by point
    values = get_values(params).asc(:number)
    data = {}
    data["min"] = values.first.number
    data["max"] = values.last.number
    data["avg"] = values.collect(&:number).sum.to_f/values.length
    
    # with group by point
    # hash = values.asc(:number).group_by(&:point_id)
    # 
    # data = {}
    # data["min"] = []
    # data["max"] = []
    # data["avg"] = []
    # 
    # hash.each do |k,v|
    #   data["min"] << v.first.number
    #   data["max"] << v.last.number
    #   data["avg"] << v.collect(&:number).sum.to_f/v.length
    # end
    output_hash("propval", params, data)
  end  
  
  private 
  
  # if there is an var_id passed then we want that id, if not the params[:variable] is used
  # if there is a number (no) passed then we have params[:year1] and params[:year2] (used for diff values)
  def self.get_values params, var_id=false, no=""
    model_id = Model.find_id_by_name(params[:model])
    scenario_id = Scenario.find_id_by_name(params[:scenario])
    var_id = Variable.find_id_by_name(params[:variable]) if params[:variable]
    
    year = params["year#{no}"]
    month = params["month#{no}"]
    
    v = Value.only(:number, :point_id)
    v = v.where(year: year) if year # for /propval/Mo/Sc/all/all/Var.Out
    v = v.where(month: month) if month # for aggregated values
    v.where(model_id: model_id, scenario_id: scenario_id, variable_id: var_id)
  end
  
  def self.output_hash what, params, data
    {
      map: what,
      model_name: params[:model], scenario_name: params[:scenario],
      year: params[:year], 
      month: params[:month],
      data: data
    }
  end
end