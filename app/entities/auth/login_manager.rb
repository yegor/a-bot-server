module Entities
  module Auth

    class LoginManager

      include ::Phoenix::Entity::Base

      presence :global
      singleton!

      def initialize
        p "INTIALIZING LOGIN MANAGER"
      end

      #  Arguments are:
      #    credential: Messages::Auth::Credential( int32 id, string email, string password )
      #
      #  Result is:
      #    Entities::Auth::Account
      #
      def login( credential )
        p "SOMEBODY IS LOGGING IN"
        self.session { |data| data[:account] = ::Entities::Auth::Account.new( Fiber.current[:context][:connection] ) }
      end


    end

  end
end
