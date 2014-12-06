ENV["PHOENIX_ENV"] ||= "development"
ENV["PHOENIX_ROOT"] ||= File.expand_path( File.join(__FILE__, "..", "..") )

require "phoenix/boot.rb"

Signal.list.keys.each do |name|
  Signal.trap(name) { puts "!" * 100; puts name; }
end

sleep
