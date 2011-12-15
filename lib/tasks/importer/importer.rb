require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "json"
require 'bigdecimal' # needed because of float rounding errors

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

    year_range, multi = 0
    
    # get values from first lines (year range and multiplicator)
    File.open(@filepath).each do |line|
      begin
        year_range = get_year_range(line)
        multi = get_multi(line)
        break if multi
      rescue Exception => e
        puts "Error in #{@filepath}: #{e.message}"
      end
    end
    
    line_counter, year, point = 0
    start_year = year_range.first
    end_year = year_range.last
    
    File.open(@filepath).each do |line|
        begin
          line_counter += 1
          next if line_counter <= 5 # ignore first lines

          if point?(line)
            year = start_year # sets year to start year
            point = create_point(line) # generate a new point
            if point.new_record?
              File.open("db/data/points.json","a+") { |f| f.write(point.to_json + "\n")}
            end
            next
          end
          
          # create values in year range
          if year >= start_year && year <= end_year

            month = 1 # every line begins with month 1
            
            line.split(" ").each do |value|
              number = BigDecimal.new(value) * BigDecimal.new(multi)
              
              if month > 12
                raise "Error in #{@filepath} on line #{line_counter}. Wrong number of months"
              end
              
              # Value.create!(model: model, scenario: scenario, variable: variable,
              #               point: point, year: year, month: month, number: number)
              # puts "#{year}-#{month} no: #{number}, #{model.name}/#{scenario.name}/#{variable.name}"
              v = Value.new(model: model, scenario: scenario, variable: variable,
                            point: point, year: year, month: month, number: number) 
              File.open("db/data/values.json","a+") { |f| f.write(v.to_json + "\n")}
              month += 1
            end
            year += 1
          end
        rescue Exception => e
          puts "Error in #{@filepath} on line #{line_counter}: #{e.message}"
        end
      end
  end
  
  private
    
    def get_year_range(line)
      result = line.match(/Years=(\d+)-(\d+)/)
      result ? [result[1].to_i, result[2].to_i] : nil
    end
    
    def get_multi(line)
      result = line.match(/Multi=\s*(\d+\.\d+)/)
      result ? result[1] : nil
    end
    
    def create_point(line)
      if result = line.match(/Grid-ref=\s*(\d+),\s*(\d+)/)
        x = result[1].to_i
        y = result[2].to_i
        Point.find_or_initialize_by(x: x, y: y)
      end
    end
    
    def point?(line)
      !!(line =~ /Grid-ref/)
    end
  
end