namespace :db do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Get all clima data"
  task :get_data => :environment do
    start_time = Time.now
    puts "start Import..."
    
    source = Rails.env.production? ? "db/data" : "spec/fixtures"
    source = "lib/tasks/importer/debug" if Rails.env.development?
    
    folder = File.join(Rails.root + source)
    
    Dir.foreach(folder) do |file|
      next if file == '.' or file == '..'
      
      start_file_time = Time.now
      importer = Importer.new(folder, file)
      importer.execute
      puts "'#{file}' imported in #{(Time.now - start_file_time).round(2)} s"
    end
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "Imports clima data in mongodb"
  task :import => :environment do  
    start_time = Time.now
    
    `mongoimport -d #{db_name} -c values db/data/values.json`
    `mongoimport -d #{db_name} -c points db/data/points.json`
    
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  def db_name
    Rails.application.class.parent_name.downcase + "_" + Rails.env
  end
  
end