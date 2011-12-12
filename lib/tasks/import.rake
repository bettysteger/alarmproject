namespace :import do

  require File.join(Rails.root + "lib/tasks/importer/importer")
  
  desc "Imports clima data"
  task :data => :environment do
    source = Rails.env == :production ? "db/data" : "spec/fixtures"
    folder = File.join(Rails.root + source)
    
    Dir.foreach(folder) do |file|
      next if file == '.' or file == '..'
      importer = Importer.new(folder, file)
      importer.execute
    end
  end
  
end