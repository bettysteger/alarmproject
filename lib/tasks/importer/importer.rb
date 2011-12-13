require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require 'bigdecimal' # needed because of float - float calculation round

class Importer

  # initialize new import, default model type is Europe
  def initialize folder, file, model = "Europe"
    @filepath = File.join(folder, file)
    @model = model
    @scenario = file.split(".").first
    @variable = file.split(".").last
  end
  
  # executes the import for one file
  def execute
    model = Model.find_or_create_by(name: @model)
    scenario = Scenario.find_or_create_by(name: @scenario)
    variable = Variable.find_or_create_by(name: @variable)

    start_values, start_year, end_year, multi, year, point = nil
    line_counter = 0
  
    File.open(@filepath).each do |line|
      begin
        month = 1
        line_counter += 1
        start_year = get_start_year(line) if start_year == nil
        end_year = get_end_year(line) if end_year == nil
        multi = get_multi(line) if multi == nil
        point = create_point(line) if point == nil #|| point.is_a?(Point)
        
        if create_point(line) 
          year = start_year
          start_values = true
          next
        end
        
        if start_values
          line.split(" ").each do |value_number|
            number = BigDecimal.new(value_number) * BigDecimal.new(multi.to_s)
            
            if month > 12
              raise "Error in #{@filepath} on line #{line_counter}. Wrong number of months"
            end
            Value.create!(model: model, scenario: scenario, variable: variable, 
                     point: point, year: year, month: month, number: number)
            month += 1
          end
          point = nil if year >= end_year # to generate a new point on the next grid_ref
          year += 1
        end
      rescue Exception => e
        puts "Error in #{@filepath}: #{e.message}"
      end
    end
  end
  
  private
    
    def get_start_year(line)
      result = line.match(/Years=(\d+)-(\d+)/)
      result ? result[1].to_i : nil
    end
    
    def get_end_year(line)
      result = line.match(/Years=(\d+)-(\d+)/)
      result ? result[2].to_i : nil
    end
    
    def get_multi(line)
      result = line.match(/Multi=\s*(\d+\.\d+)/)
      result ? result[1].to_f : nil
    end
    
    def create_point(line)
      if result = line.match(/Grid-ref=\s*(\d+),\s*(\d+)/)
        x = result[1].to_i
        y = result[2].to_i
        Point.find_or_create_by(x: x, y: y)
      end
    end
  
end