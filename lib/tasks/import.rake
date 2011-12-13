namespace :import do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Imports clima data"
  task :data => :environment do
    start_time = Time.now
    puts "start Import..."
    
    source = Rails.env.production? ? "db/data" : "spec/fixtures"
    #source = "lib/tasks/importer/debug" if Rails.env.development?
    
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
  
end