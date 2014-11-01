module Entities
  module Game
    module Base

      class Player

        include ::Phoenix::Entity::Base

        presence :global

        attr_accessor :account

        def initialize(account)
            self.account = account
        end

        #  Client-side methods available through this entity:
        #
        #  update_cell( Messages::Game::Base::Cell( int32 index, int32 player, int32 armySize ) cell )
        #  switch_turn( Entities::Game::Base::Player player )
        #  log_message_from_server( string text )
        #  error_message_from_server( string text )
        #

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Cell( int32 index, int32 player, int32 armySize )[] cells )
        #
        def get_state
          raise NotImplementedError.new
        end

        #  Arguments are:
        #    from: int32
        #    to: int32
        #
        #  Result is:
        #    (void)
        #
        def make_move( from, to )
          raise NotImplementedError.new
        end

        #  Result is:
        #    (void)
        #
        def end_turn
          raise NotImplementedError.new
        end

        def entity_id
          @entity_id ||= Celluloid.uuid
        end


      end

    end
  end
end
