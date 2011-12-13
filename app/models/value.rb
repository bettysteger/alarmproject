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
  
  belongs_to :model
  belongs_to :scenario
  belongs_to :variable
  belongs_to :point
end