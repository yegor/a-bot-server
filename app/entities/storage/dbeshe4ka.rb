module Entities
  module Storage

    class Dbeshe4ka
      include ::Phoenix::Entity::Base

      presence :global
      group    :true

      def initialize(data = nil)
        @data = data
      end

      def hello
        sleep 2
        puts "I am #{@data}"
      end

      def value
        sleep 3
        rand(100)
      end
    end

  end
end