module Entities
  module Auth

    class LoginManager

      include ::Phoenix::Entity::Base

      presence :global

      def initialize
        p "INTIALIZING LOGIN MANAGER"
      end

      #  Arguments are:
      #    credentials: Messages::Auth::Credentials( int32 id, string email, string password )
      #
      #  Result is:
      #    Entities::Auth::Account
      #
      def login( credentials )
        p "SOMEBODY IS LOGGING IN"
        return ::Entities::Auth::Account.new
      end


    end

  end
end
