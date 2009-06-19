namespace :db do   
  desc "reset db,clone test, load fixtures under db/bootstrap"
  task :bootstrap do |task_args|  
    %w(environment db:migrate:reset
       db:test:clone db:bootstrap:load).each { |t| Rake::Task[t].invoke  }
    puts "ok"
  end  
  namespace :bootstrap do
   desc "Load initial database fixtures (in db/bootstrap/*.yml) into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
   task :load => :environment do
     require 'active_record/fixtures'
     ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
     (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'bootstrap', '*.{yml,csv}'))).each do |fixture_file|
       Fixtures.create_fixtures('db/bootstrap', File.basename(fixture_file, '.*'))
     end
   end
  end 
end  
