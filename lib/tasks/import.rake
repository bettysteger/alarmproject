namespace :db do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  source = Rails.env.test? ? "spec/fixtures" : "db/data"
  @folder = File.join(Rails.root + source)
  
  desc "Get clima data and push it into json files"
  task :get_data => :environment do
    start_time = Time.now
    
    puts "Start converting... at #{start_time}"
    
    cleanup
    prepare_import
    execute_import

    puts "Convert finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "Imports clima data from json files into mongo db"
  task :import => :environment do  
    start_time = Time.now
    
    Dir[@folder + "/json/*values.json"].each do |file|
      `mongoimport -d #{db_name} -c values #{file}`
    end
    Dir[@folder + "/json/*points.json"].each do |file|
      `mongoimport -d #{db_name} -c points #{file}`
    end
    
    puts "Import finished in #{(Time.now - start_time).round(2)} s"
  end
  
  desc "All in-one importer"
  task :full_import => :environment do
    Rake::Task["db:get_data"].execute
    Rake::Task["db:import"].execute
  end
  
  
  # Helper methods:
  
  # delete old jsons files
  def cleanup
    Dir[@folder + "/json/*.json"].each do |file|
      File.delete(file)
    end
  end  
  
  # prepare import (sequential)
  def prepare_import
     Dir[@folder + "/*.*"].each do |file|
       start_file_time = Time.now
       importer = Importer.new(@folder, file)
       importer.prepare
       puts "'#{File.basename(file)}' prepared for import in #{(Time.now - start_file_time).round(2)} s"
    end
  end
  
  # execute import (parallel)
  def execute_import
    Parallel.each(Dir[@folder + "/*.*"]) do |file|
      start_file_time = Time.now
      puts "Start import file #{File.basename(file)}..."
      importer = Importer.new(@folder, file)
      importer.execute
      puts "'#{File.basename(file)}' converted into json for import in #{(Time.now - start_file_time).round(2)} s"
    end
  end
  
  def db_name
    Rails.application.class.parent_name.downcase + "_" + Rails.env
  end
  
end