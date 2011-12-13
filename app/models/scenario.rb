class Scenario
  include Mongoid::Document

  field :name, type: String
  field :desc, type: String
  key   :name
  index :name, unique: true
  
  validates :name, presence: true, uniqueness: true
  
  has_many :values
end