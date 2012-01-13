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
    model = Model.find_by_name(params[:model])
    scenario = Scenario.find_by_name(params[:scenario])
    var = Variable.find_by_name(params[:variable])
    values = Value.where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year], month: params[:month])
    data = {}
    data[params[:variable]] = values.map(&:number)
    output_hash("val", params, data)
  end
  
  def self.mapval_all params
    model = Model.find_by_name(params[:model])
    scenario = Scenario.find_by_name(params[:scenario])
    values = Value.where(model_id: model, scenario_id: scenario, year: params[:year], month: params[:month])
    data = {}
    Variable.all.each do |var|
      data[var.name] = values.where(variable_id: var.id).map(&:number)
    end
    output_hash("val", params, data)
  end
  
  def self.mapvalagr_var params
    model = Model.find_by_name(params[:model])
    scenario = Scenario.find_by_name(params[:scenario])
    var = Variable.find_by_name(params[:variable])
    
    data = {}
    data[params[:variable]] = []
    
    #Value.all.max(:number)
    #Value.all.min(:number)
    #Value.all.avg(:number)
    #raise wtf.inspect
    
    values = Value.only(:number, :point_id).where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year])
    #data[params[:variable]] = values.map_reduce(:number).last.number
    #data = values.map_reduce(:number).map(&:number)
    
    hash = values.asc(:number).group_by(&:point_id)
    hash.each do |k,v|
      data[params[:variable]] << v.first.number if params[:function] == "min"
      data[params[:variable]] << v.last.number if params[:function] == "max"
      data[params[:variable]] << v.collect(&:number).sum.to_f/v.length if params[:function] == "avg"
    end
    
    # map = "function(){ emit(new Date(this.created_at.getYear(), this.created_at.getMonth(), this.created_at.getDate()), {amount: this.amount}); };"
    # reduce = "function(key, values){ var sum = 0; values.forEach(function(doc){ sum += doc.amount; }); return {amount: sum};};"
    # 
    # v = Value.collection.map_reduce(map, reduce).find.to_a
    # raise v.inspect
    
    #values = Value.where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year])
    #values.send(params[:function], :number)
    #raise Value.all.group_by{ |v| v.point.to_hash}.inspect
    #values.group_by(&:point).max(:number)
    
    # data = {}
    # values = Value.where(model_id: model, scenario_id: scenario, variable_id: var, year: params[:year])#.group_by(&:point_id)
    # points = values.collect(&:point)
    # points.each do |p|
    #   data[params[:variable]] = p.values.max(:number)
    # end
    #values.group(:point_id).max(:number)
    # values.each do |k, v|
    #   puts k
    #   
    # end 
    # 
    # raise values.inspect
    
    
    #data = {}
    #data[params[:variable]] = values #values.send(params[:function], :number, :group => :point_id)
    output_hash("val", params, data)
  end
  
  def self.mapvalagr_all params
    model = Model.find_by_name(params[:model])
    scenario = Scenario.find_by_name(params[:scenario])
    values = Value.where(model_id: model, scenario_id: scenario, year: params[:year])
    data = {}
    Variable.all.each do |var|
      data[var.name] = values.where(variable_id: var.id).send(params[:function], :number)
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
  
  def self.wtf
    Value.map_reduce(:number)#.first.number
  end

end
