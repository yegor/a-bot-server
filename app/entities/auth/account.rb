module Entities
  module Auth

    class Account

      include ::Phoenix::Entity::Base

      presence :global

      #  Properties defined on this entity (will be sent to clients):
      #
      #  id: int32
      #  name: string
      #

      attr_accessor :connection

      def initialize(connection)
        self.connection = connection
        self.id = 123
        self.name = "Dat mah name"
      end

    end

  end
end
