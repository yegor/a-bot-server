ENV["PHOENIX_ENV"] ||= "development"
ENV["PHOENIX_ROOT"] ||= File.expand_path( File.join(__FILE__, "..", "..") )

require "phoenix/boot.rb"

puts "!" * 100
p Thread.list
sleep
