require "mysql2celluloid"

Phoenix.application.on(:start) do
  ActiveRecord::Base.establish_connection( Phoenix.application.config.database )
  ActiveRecord::Base.logger = Phoenix.application.logger
end