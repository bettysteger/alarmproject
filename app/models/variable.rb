class Variable < Name
  include Mongoid::Document
  
  field :name, type: String
  field :desc, type: String
  index :name, unique: true
  
  validates :name, presence: true, uniqueness: true
  
  has_many :values
end