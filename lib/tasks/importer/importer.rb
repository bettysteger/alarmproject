require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

class Importer
  
  def initialize folder, file, model = "Europe"
    @filepath = File.join(folder, file)
    @model = model
    @scenario = file.split(".").first
    @variable = file.split(".").last
  end

  def execute
    model = Model.find_or_create_by(name: @model)
    scenario = Scenario.find_or_create_by(name: @scenario)
    variable = Variable.find_or_create_by(name: @variable)
    
    start_values = false
    year = 2001
    
    File.open(@filepath).each do |line|
      month = 1
      
      if line =~ /Grid-ref/
        puts line
        year = 2001
        start_values = true
        next
      end
      
      if start_values
        line.split(" ").each do |value|
          puts "year: #{year} - month: #{month} - value: #{value}"
          month += 1
        end
        year += 1
        #start_values = false # only first line/year
      end
    end
  end
  
end