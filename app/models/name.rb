class Name
  def self.find_id_by_name name
    object = self.only(:id).where(name: name)
    raise "Error: #{self.name} nicht in der DB" unless object.first
    object.first.id
  end
end