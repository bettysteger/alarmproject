class Point
  include Mongoid::Document

  field :x, type: Float
  field :y, type: Float
end