class Point
  include Mongoid::Document

  field :x,     type: Float
  field :y,     type: Float
  field :year,  type: Integer
  field :month, type: Integer
  field :value, type: Float
  
  validates :x,         presence: true
  validates :y,         presence: true
  validates :year,      presence: true
  validates :month,     presence: true
  validates :value,     presence: true
  validates :model,     presence: true
  validates :scenario,  presence: true
  validates :variable,  presence: true

  belongs_to :model
  belongs_to :scenario
  belongs_to :variable
end