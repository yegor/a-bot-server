module Entities
  module Auth

    class Account

      include ::Phoenix::Entity::Base

      presence :global

      #  Result is:
      #    string
      #
      def get_name
        raise NotImplementedError.new
      end


    end

  end
end
