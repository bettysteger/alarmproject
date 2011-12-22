class Value
  include Mongoid::Document

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
    #raise output_hash("val", params, data).inspect
    output_hash("val", params, data)
  end
  
  private 
  
  def self.output_hash what, params, data
    {
      map: what,
      model_name: params[:model], scenario_name: params[:scenario],
      year: params[:year], month: params[:month],
      data: data
    }
  end

end
