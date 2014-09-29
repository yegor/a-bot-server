module Entities
  class Player
    include ::Phoenix::Entity::Base

    presence :global

    def initialize(data)
      @data = data
    end

    def hello_world
      sleep 3
      puts "Hello world! I have #{@data}!"
    end

  end
end