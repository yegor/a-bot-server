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
      #    match_request: Messages::Game::MatchRequest( int32 match_type )
      #
      #  Result is:
      #    (void)
      #
      def find_match(match_request)
        account = self.session[:account]

        enqueue(account)
        
        if accounts = dequeue(2)
          logger.debug "Starting a match between #{accounts.first} and #{accounts.second}"
          start_match(accounts)
        else
          logger.debug "Not enough alive accounts to start a match - waiting"
        end
      end

      #  Arguments are:
      #    match_request: Messages::Game::MatchRequest( int32 match_type )
      #
      #  Result is:
      #    (void)
      #
      def find_match_with_bot(match_request)
        account = self.session[:account]
        bot     = ::Entities::Game::Bots::Anarki.new(self)

        start_match([account, bot])
      end

    protected 

      #  Enqueues the player onto the queue.
      #
      def enqueue(account)
        logger.debug "Putting #{account} onto match queue..."
        self.queue << account
      end

      #  Dequeues +count+ alive players.
      #
      def dequeue(count = 2)
        logger.debug "Checking queue for at least #{count} alive accounts"
        
        self.queue = self.queue.select { |account| account.connection.alive? }
        self.queue.slice!(0, count) if self.queue.size >= count
      end

      #  Starts the match and notifies parties.
      #
      def start_match(accounts, options = {})
        match = ::Entities::Game::Base::Match.new()

        player1 = ::Entities::Game::Base::Player.new(accounts.first, match)
        player2 = ::Entities::Game::Base::Player.new(accounts.second, match)

        match.add_player(player1)
        match.add_player(player2)

        match.generate_field

        self.to(accounts.first.connection).match_ready(match, player1)
        self.to(accounts.second.connection).match_ready(match, player2)

        match.end_turn(0) # FIXME: OLOLO!!!!!
      end

    end

  end
end
