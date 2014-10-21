module Entities
  module System

    #  Simple system entity dedicated to testing connectivity, computing
    #  ping time and so on.
    #
    class Handle
      
      include ::Phoenix::Entity::Base

      presence :global

      #  Result is:
      #    int32
      #
      def increment
        @counter ||= 100
        @counter += 1
      end

      #  Lazily initializes an entity id.
      def entity_id
        @entity_id ||= Celluloid.uuid
      end

    end

  end
end