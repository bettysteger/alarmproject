class Scenario
  include Mongoid::Document

  field :name, type: String
  field :desc, type: String
  
  validates :name, presence: true, uniqueness: true
  
  has_many :points
end