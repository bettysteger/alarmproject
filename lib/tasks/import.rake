namespace :db do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Get clima data and push it into json files"
  task :get_data => :environment do
    start_time = Time.now
    
    puts "Start converting... at #{start_time}"
    
    source = Rails.env.test? ? "spec/fixtures" : "db/data"
    
  #  source = "spec/fixtures"
    folder = File.join(Rails.root + source)
    
    cleanup(folder)
    prepare_import(folder)
    execute_import(folder)

    puts "Convert finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "Imports clima data from json files into mongo db"
  task :import => :environment do  
    start_time = Time.now
    
    `mongoimport -d #{db_name} -c values db/data/json/*.values.json`
    `mongoimport -d #{db_name} -c points db/data/json/*.points.json`
    
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "All in-one importer"
  task :full_import => [:environment, :get_data, :import]
  
  # Helper methods:
  
  # delete old jsons files
  def cleanup(folder)
    Dir[folder + "/json/*.json"].each do |file|
      File.delete(file)
    end
  end  
  
  # prepare import (sequential)
  def prepare_import(folder)
     Dir[folder + "/*.*"].each do |file|
       start_file_time = Time.now
       importer = Importer.new(folder, file)
       importer.prepare
       puts "'#{File.basename(file)}' prepared for import in #{(Time.now - start_file_time).round(2)} s"
    end
  end
  
  # execute import (parallel)
  def execute_import(folder)
    Parallel.each(Dir[folder + "/*.*"]) do |file|
      start_file_time = Time.now
      puts "Start import file #{File.basename(file)}..."
      importer = Importer.new(folder, file)
      importer.execute
      puts "'#{File.basename(file)}' converted into json for import in #{(Time.now - start_file_time).round(2)} s"
    end
  end
  
  def db_name
    Rails.application.class.parent_name.downcase + "_" + Rails.env
  end
  
end