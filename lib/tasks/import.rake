namespace :db do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Get all clima data"
  task :get_data => :environment do
    start_time = Time.now
    puts "start Import... at #{start_time}"
    
    source = Rails.env.test? ? "spec/fixtures" : "db/data"
    folder = File.join(Rails.root + source)
    
    Dir[folder + "/*.*"].each do |file|
    #Parallel.each(Dir[folder + "/*.*"], :in_threads=>6) do |file|
      start_file_time = Time.now
      puts "start file..."
      importer = Importer.new(folder, file)
      importer.execute
      puts "'#{File.basename(file)}' imported in #{(Time.now - start_file_time).round(2)} s"
    end
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "Imports clima data in mongodb"
  task :import => :environment do  
    start_time = Time.now
    
    `mongoimport -d #{db_name} -c values db/data/json/*.values.json`
    `mongoimport -d #{db_name} -c points db/data/json/*.points.json`
    
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  def db_name
    Rails.application.class.parent_name.downcase + "_" + Rails.env
  end
  
end