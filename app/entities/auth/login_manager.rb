module Entities
  module Auth

    class LoginManager

      include ::Phoenix::Entity::Base

      presence :global

      #  Arguments are:
      #    credentials: Messages::Auth::Credentials( int32 id, string email, string password )
      #
      #  Result is:
      #    Entities::Auth::Account
      #
      def login( credentials )
        raise NotImplementedError.new
      end


    end

  end
end
