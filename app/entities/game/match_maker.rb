module Entities
  module Game

    class MatchMaker

      include ::Phoenix::Entity::Base

      presence :global
      singleton!

      attr_accessor :queue

      #  Client-side methods available through this entity:
      #
      #  match_ready( Entities::Game::Base::Match match, Entities::Game::Base::Player player )
      #  match_timed_out(  )
      #

      def initialize
        p "INITIALIZING MATCH MAKER"
        self.queue = []
      end

      #  Arguments are:
      #    matchRequest: Messages::Game::MatchRequest( int32 matchType )
      #
      #  Result is:
      #    (void)
      #
      def find_match( matchRequest )
        account = self.session[:account]

        p account
        p "FINDING MATCH"

        self.queue << account

        while self.queue.size >= 2
          p "MATCH FOUND"

          match = ::Entities::Game::Base::Match.new()

          begin
            self.to(self.queue[0].connection).match_ready( match, ::Entities::Game::Base::Player.new(self.queue[0]) )
          rescue Phoenix::Entity::Proxies::Client::DeadClientException
            p "FIRST CLIENT IS DEAD"
            self.queue = self.queue[1 .. -1]
            next
          end

          # second just came, we assume he is not dead ;)
          self.to(self.queue[1].connection).match_ready( match, ::Entities::Game::Base::Player.new(self.queue[1]) )

          p "MATCH ACTUALLY STARTED"

          self.queue = self.queue[2 .. -1]
        end

      end


    end

  end
end
