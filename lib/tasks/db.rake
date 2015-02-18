require 'sequel'             
require 'init_db' 
namespace :db do             
  Sequel.extension :migration
  desc 'make rules table'    
  task :migrate do |task, args|
    Sequel::Migrator.apply(DB, "db/migrate")
  end

  desc 'rollback rules table'
  task :rollback do |task, args|
    Sequel::Migrator.apply(DB, "db/migrate", 0)
  end
end
