ENV["PHOENIX_ENV"]  ||= "development"
ENV["PHOENIX_ROOT"] ||= File.expand_path( File.join(__FILE__, "..", "..") )
ENV["CONSOLE"]      = "true"

require "phoenix/boot.rb"
require "irb"

IRB.start(__FILE__)

