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
              cells: [
                Messages::Game::Base::Cell.new(id: 0,  playerId: 1, armySize: 1),
                Messages::Game::Base::Cell.new(id: 1,  playerId: 1, armySize: 2),
                Messages::Game::Base::Cell.new(id: 2,  playerId: 1, armySize: 3),
                Messages::Game::Base::Cell.new(id: 3,  playerId: 1, armySize: 4),
                Messages::Game::Base::Cell.new(id: 4,  playerId: 1, armySize: 5),
                Messages::Game::Base::Cell.new(id: 5,  playerId: 1, armySize: 6),
                Messages::Game::Base::Cell.new(id: 6,  playerId: 2, armySize: 1),
                Messages::Game::Base::Cell.new(id: 7,  playerId: 2, armySize: 2),
                Messages::Game::Base::Cell.new(id: 8,  playerId: 2, armySize: 3),
                Messages::Game::Base::Cell.new(id: 9,  playerId: 2, armySize: 4),
                Messages::Game::Base::Cell.new(id: 10, playerId: 2, armySize: 5),
                Messages::Game::Base::Cell.new(id: 11, playerId: 2, armySize: 6),
              ],
              nodes: [

              ]
            ),
            players: Messages::Game::Base::MatchPlayers.new(),
            turnNumber: 100,
            turnPlayerId: 500,
          )
        end

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 playerId, int32 armySize )[] cells, Messages::Game::Base::Node( int32 from, int32 to )[] nodes ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turnNumber, int32 turnPlayerId )
        #
        def get_state
          return @state
        end

      end

    end
  end
end
