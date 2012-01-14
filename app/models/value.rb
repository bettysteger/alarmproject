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
  
  def self.mapval_var params
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    var = Variable.find_id_by_name(params[:variable])
    values = Value.where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year], month: params[:month])
    data = {}
    data[params[:variable]] = values.map(&:number)
    output_hash("val", params, data)
  end
  
  def self.mapval_all params
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    values = Value.where(model_id: model, scenario_id: scenario, year: params[:year], month: params[:month])
    data = {}
    Variable.all.each do |var|
      data[var.name] = values.where(variable_id: var.id).map(&:number)
    end
    output_hash("val", params, data)
  end
  
  def self.mapvalagr_var params
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    var = Variable.find_id_by_name(params[:variable])
    
    data = {}
    data[params[:variable]] = []
    
    values = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year])
    hash = values.asc(:number).group_by(&:point_id)
    hash.each do |k,v|
      data[params[:variable]] << v.first.number if params[:function] == "min"
      data[params[:variable]] << v.last.number if params[:function] == "max"
      data[params[:variable]] << v.collect(&:number).sum.to_f/v.length if params[:function] == "avg"
    end
    output_hash("val", params, data)
  end
  
  def self.mapvalagr_all params
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    
    data = {}
    Variable.all.each do |var|
      data[var.name] = []
      values = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var.id, year: params[:year])
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
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    var = Variable.find_id_by_name(params[:variable])
    year1 = params[:year1]
    year2 = params[:year2]
    month1 = params[:month1]
    month2 = params[:month2]
    
    data = {}
    data[params[:variable]] = []
    
    values1 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: year1, month: month1)
    hash1 = values1.group_by(&:point_id)
    
    values2 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: year2, month: month2)
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
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    year1 = params[:year1]
    year2 = params[:year2]
    month1 = params[:month1]
    month2 = params[:month2]
    
    data = {}

    Variable.all.each do |var|
      data[var.name] = []
      values1 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var.id, year: year1, month: month1)
      hash1 = values1.group_by(&:point_id)
      
      values2 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var.id, year: year2, month: month2)
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
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    var = Variable.find_id_by_name(params[:variable])
    year1 = params[:year1]
    year2 = params[:year2]
    function1 = params[:function1]
    function2 = params[:function2]

    data = {}
    data[params[:variable]] = []
    
    values1 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: year1)
    hash1 = values1.asc(:number).group_by(&:point_id)
    
    values2 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: year2)
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
    output_hash("val", params, data)
  end

  def self.mapdiffagr_all params
    model = Model.find_id_by_name(params[:model])
    scenario = Scenario.find_id_by_name(params[:scenario])
    year1 = params[:year1]
    year2 = params[:year2]
    function1 = params[:function1]
    function2 = params[:function2]
    
    data = {}

    Variable.all.each do |var|
      data[var.name] = []
      
      values1 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var.id, year: year1)
      hash1 = values1.asc(:number).group_by(&:point_id)
    
      values2 = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var.id, year: year2)
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
    output_hash("val", params, data)
  end
  
  private 
  
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