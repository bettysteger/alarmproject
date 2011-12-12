namespace :db do
  namespace :mongo do

    # start db server
    task :start do
      pr = get_pids
      if pr.length == 0
        sh "mongod --dbpath=#{Rails.root}/db/ >> #{Rails.root}/log/mongodb.log"
        puts "mongod running - press return."
      else
        puts "mongod already running - rake db:mongo:stop first."
      end
    end

    # stop db server
    task :stop do
      pr = get_pids
      if pr.length > 0
        pr.each do |p|
        begin
          Process.kill(2,p)
        rescue SystemCallError => e
                raise e
              else
                puts "Killed mongod #{p} with signal 2"
              end
        end
      else
        puts "No mongod process is running."
      end
    end

  end
end

# return array with mongod PIDs (or empty)
def get_pids
  require 'sys/proctable'
  include Sys
  
  procs = Array.new

  ProcTable.ps {|p|
    if p.name == "mongod"
      procs << p.pid
    end
  }
  return procs
end