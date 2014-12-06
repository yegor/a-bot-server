ENV["PHOENIX_ENV"] ||= "development"
ENV["PHOENIX_ROOT"] ||= File.expand_path( File.join(__FILE__, "..", "..") )

require "phoenix/boot.rb"

stop = false
Signal.trap('INT') { stop = true }
sleep(1) until stop
