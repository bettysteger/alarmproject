class Variable
  include Mongoid::Document
  
  field :name, type: String
  field :desc, type: String
  key   :name
  
  validates :name, presence: true, uniqueness: true
  
  has_many :values
end