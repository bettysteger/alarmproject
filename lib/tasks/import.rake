namespace :import do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Imports clima data"
  task :data => :environment do
    startTime = Time.now
    if Rails.env == :production
      source = "db/data"
    elsif Rails.env == :test
      source = "spec/fixtures"
    else
      source = "lib/tasks/importer/debug"
    end
    folder = File.join(Rails.root + source)
    
    Dir.foreach(folder) do |file|
      next if file == '.' or file == '..'
      importer = Importer.new(folder, file)
      puts "Import started"
      importer.execute
      puts "Import finished in " + (Time.now - startTime).to_s + " s"
    end
  end
  
end