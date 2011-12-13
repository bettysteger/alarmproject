class Point
  include Mongoid::Document

  field :x,     type: Float
  field :y,     type: Float
  key :x, :y
  
  validates :x, presence: true
  validates :y, presence: true
  
  has_many :values
end
