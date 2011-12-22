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
  
  def self.mapval_all params
    model = Model.where(name: params[:model]).first.id
    scenario = Scenario.where(name: params[:scenario]).first.id
    value = Value.where(model_id: model, scenario_id: scenario, year: params[:year], month: params[:month]).all.to_a
    raise value.inspect
  end
  
  def self.mapval_variable params
    params[:model]
    params[:scenario]
    params[:year]
    params[:month]
    params[:variable]
  end
  
  def self.output_hash
    # {
    #   "map":"val",
    #   "model_name":"Europe", "scenario_name":"BAMBU",
    #   "year":2011, "month":11,
    #   "data": {
    #     "pre":[[null,null,...],[...,null,122.3,118.8,130.1,null,...],...],
    #     "tmp":[[null,null,...],[...,null,8.2,8.3,7.4,null,...],...]
    #   }
    # }
  end
  
end