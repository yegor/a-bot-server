module Entities
  class Player
    include ::Phoenix::Entity::Base

    presence :global

    def initialize(id = nil)
      @id = id
    end

    def hello_world
      sleep 3
      puts "Hello world! I have #{@data}!"
    end

    def value
      sleep 3
      rand(100)
    end

    def entity_id
      @id
    end

  end
end