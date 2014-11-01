require 'logger'
require 'active_record'

namespace :db do
  
  def create_database(config)
    options = {charset: 'utf8', collation: 'utf8_unicode_ci'}

    create_db = lambda do |config|
      ActiveRecord::Base.establish_connection( config.merge(database: nil) )
      ActiveRecord::Base.connection.create_database( config[:database], options )
      ActiveRecord::Base.establish_connection( config )
      ActiveRecord::Base.logger = Logger.new( STDOUT )
    end

    begin
      create_db.call(config)
    rescue
      $stderr.puts "Couldn't create database for #{config.inspect}, charset: utf8, collation: utf8_unicode_ci"
      $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config[:charset]
    end
  end

  namespace :generate do

    task :model => :migration do
      name = ENV[ "MODEL" ]
      parts = [ "models" ] + name.split("/")

      dir = Phoenix.application.root.join( "app", *parts[0...-1] )
      FileUtils.mkdir_p( dir )

      File.open( dir.join( parts.last + ".rb" ), "wb" ) do |file|
        padding = ""

        parts[0...-1].each do |part|
          file << "#{ padding }module #{ part.camelize }\n"
          padding << "  "
        end

        file << "\n#{ padding }class #{ parts.last.classify } < ActiveRecord::Base\n"
        file << "\n#{ padding }end\n\n"

        parts[0...-1].each do |part|
          padding = padding[2..-1]
          file << "#{ padding }end\n"
        end        
      end
    end

    task :migration do
      name = ENV[ "MODEL" ].gsub("/", "_")

      FileUtils.mkdir_p( Phoenix.application.root.join( "db", "migrate" ) )

      file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_create_#{ name }.rb"
      File.open( Phoenix.application.root.join( "db", "migrate", file_name ), "wb" ) do |file|
        file << "class Create#{ name.classify } < ActiveRecord::Migration\n"
        file << "  def change\n"
        file << "  end\n"
        file << "end"
      end
    end

  end
 
  task :environment do
    @migration_paths = []
    @migration_paths << ENV['MIGRATIONS_DIR'] if ENV['MIGRATIONS_DIR']
    @migration_paths << Phoenix.application.root.join("db", "migrate")
  end

  task :configure_connection => :environment do
    ActiveRecord::Base.establish_connection( Phoenix.application.config.database )
    ActiveRecord::Base.logger = Phoenix.application.logger
  end

  desc 'Create the database from config/database.yml for the current PHOENIX_ENV'
  task :create => :configure_connection do
    create_database( Phoenix.application.config.database )
  end

  desc 'Drops the database for the current PHOENIX_ENV'
  task :drop => :configure_connection do
    ActiveRecord::Base.connection.drop_database( Phoenix.application.config.database[:database] )
  end

  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate(@migration_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback => :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(@migration_paths, step)
  end

  desc "Retrieves the current schema version number"
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end