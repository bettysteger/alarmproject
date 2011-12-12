namespace :import do

  require Rails.root + "lib/tasks/importer/importer"
  
  desc "Imports clima data"
  task :data => :environment do
    folder = File.join(Rails.root + "db/data")
    
    Dir.foreach(folder) do |file|
      next if file == '.' or file == '..'
      importer = Importer.new(file)
      importer.execute
    end
  end
end