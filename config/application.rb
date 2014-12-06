ENV["PHOENIX_ENV"] ||= "development"
ENV["PHOENIX_ROOT"] ||= File.expand_path( File.join(__FILE__, "..", "..") )

require "phoenix/boot.rb"

stop = false

Signal.trap("CONT") do 
  Phoenix.application.stop
  stop = true
end

sleep(1.0) until stop
