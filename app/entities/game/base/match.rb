module Entities
  module Game
    module Base

      class Match

        include ::Phoenix::Entity::Base

        presence :global

        #  Client-side methods available through this entity:
        #
        #  update_cell( Messages::Game::Base::Cell( int32 id, int32 playerId, int32 armySize ) cell )
        #  switch_turn( Entities::Game::Base::Player player )
        #

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 playerId, int32 armySize )[] cells, Messages::Game::Base::Node( int32 from, int32 to )[] nodes ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turnNumber, int32 turnPlayerId )
        #
        def get_state
          raise NotImplementedError.new
        end


      end

    end
  end
end
