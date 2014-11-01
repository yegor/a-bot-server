module Entities
  module Game

    class MatchMaker

      include ::Phoenix::Entity::Base

      presence :global

      attr_accessor :queue

      #  Client-side methods available through this entity:
      #
      #  match_ready( Entities::Game::Base::Player player )
      #

      def initialize
        p "INITIALIZING MATCH MAKER"
        self.queue = []
      end

      #  Arguments are:
      #    account: Entities::Auth::Account
      #
      #  Result is:
      #    (void)
      #
      def find_match( account )
        p account
        p "FINDING MATCH"

        self.queue << account

        while self.queue.size >= 2
          p "MATCH FOUND"

          self.to(self.queue[0].connection).match_ready( ::Entities::Game::Base::Player.new(self.queue[0]) )
          self.to(self.queue[1].connection).match_ready( ::Entities::Game::Base::Player.new(self.queue[1]) )

          self.queue = self.queue[2 .. -1]
        end

      end


    end

  end
end
