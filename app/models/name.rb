class Name
  def self.find_by_name name
    self.where(name: name).first.id
  end
end