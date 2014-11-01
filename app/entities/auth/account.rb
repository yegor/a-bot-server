module Entities
  module Auth

    class Account

      include ::Phoenix::Entity::Base

      presence :global

      attr_accessor :connection

      def initialize(connection)
        self.connection = connection
      end

      def entity_id
        @entity_id ||= Celluloid.uuid
      end

      #  Result is:
      #    string
      #
      def get_name
        raise NotImplementedError.new
      end


    end

  end
end
