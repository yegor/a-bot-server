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

        def initialize
          @state = Messages::Game::Base::MatchState.new(
            field: Messages::Game::Base::Field.new(
              cells: (0..43).map { |x| Messages::Game::Base::Cell.new( id: x,  playerId: x < 22 ? 1 : 2, armySize: rand(8) + 1 ) },
              nodes: []
            ),
            players: Messages::Game::Base::MatchPlayers.new(),
            turnNumber: 100,
            turnPlayerId: 500,
          )
        end

        #  Result is:
        #    Messages::Game::Base::MatchState(
        #      Messages::Game::Base::Field(
        #         Messages::Game::Base::Cell( int32 id, int32 playerId, int32 armySize )[] cells,
        #         Messages::Game::Base::Node( int32 from, int32 to )[] nodes
        #      ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turnNumber, int32 turnPlayerId )
        #
        def get_state
          return @state
        end

      end

    end
  end
end
