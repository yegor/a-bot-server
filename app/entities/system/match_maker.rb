module Entities
  module System

    #  Client-side methods available through this entity:
    #
    #  match_ready( Entities::System::Match match )
    #
    class MatchMaker

      include ::Phoenix::Entity::Base

      presence :global

      def initialize
        p "INITIALIZING MATCH MAKER"
        @match = Entities::System::Match.new
      end

      #  Result is:
      #    (void)
      #
      def find_match
        sleep 2 # simulating matchmaking process
        self.to(Fiber.current[:context][:connection]).match_ready(@match)
      end

    end

  end
end
