require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "json" # speedup
require "bigdecimal" # needed because of float rounding errors

class Importer

  # initialize new import, default model type is Europe
  def initialize folder, file, model = "Europe"
    @filepath = file
    @folder = folder
    @model = model
    @scenario = File.basename(@filepath).split(".").first    
    @variable = File.basename(@filepath).split(".").last
  end
  
  # prepare mongo db with "basic" data
  def prepare
    Model.find_or_create_by(name: @model)
    Scenario.find_or_create_by(name: @scenario)
    Variable.find_or_create_by(name: @variable)
  end
  
  # executes the import for one file
  def execute
    model = Model.where(name: @model).first
    scenario = Scenario.where(name: @scenario).first
    variable = Variable.where(name: @variable).first

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
    filenumber = 1
    point_hashes = ""
    value_hashes = ""
    
    File.open(@filepath).each do |line|
        begin
          line_counter += 1
          next if line_counter <= 5 # ignore first lines
          
          puts "working on line #{line_counter}..." if line_counter % 10000 == 0

          if point?(line)
            year = start_year # sets year to start year
            point = create_point(line) # generate a new point
            point_hashes << JSON(point.to_hash) + "\n" if point.new_record?
            next
          end
          
          # create values in year range
          if year >= start_year && year <= end_year

            month = 1 # every line begins with month 1
            filenumber += 1 if line_counter % 100000 == 0 # files should not be super big
            
            line.split(" ").each do |value|
              number = BigDecimal.new(value) * BigDecimal.new(multi)
              
              if month > 12
                raise "Error in #{@filepath} on line #{line_counter}. Wrong number of months"
              end
                            
              value = {
                year: year, month: month, number: number, 
                model_id: model.id, scenario_id: scenario.id, variable_id: variable.id, point_id: point.id
              }
              value_hashes << JSON(value) + "\n"
                 
              month += 1
            end
            year += 1
          end
        rescue Exception => e
          puts "Error in #{@filepath} on line #{line_counter}: #{e.message}"
        end
      end
      write_to_json(value_hashes, "values")
      write_to_json(point_hashes, "points")
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
    
    def write_to_json(hash, what)
      File.open(json_path(what),"w+") { |f| f.write(hash)}
    end
    
    def json_path(what)
      dirpath =  File.join(@folder + "/json/")
      Dir.mkdir(dirpath) unless File.exists?(dirpath)
      name = File.basename(@filepath) + ".#{what}.json"
      json_path = dirpath + name
    end
  
end