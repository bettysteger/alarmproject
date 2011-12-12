require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

class Importer
  
  def initialize file, model = "Europe"
    @model = model
    @scenario = file.split(".").first
    @variable = file.split(".").last
  end

  def execute
    model = Model.find_or_create_by(name: @model)
    scenario = Scenario.find_or_create_by(name: @scenario)
    variable = Variable.find_or_create_by(name: @variable)
  end
  
end