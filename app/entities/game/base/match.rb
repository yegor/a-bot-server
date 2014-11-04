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
            field: nil,
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

        def add_player(player)
          @state.players.add_player(player)
        end

        def generate_field
          @state.field = Messages::Game::Base::Field.new()

          44.times do |x|
            player = @state.players.players[x < 22 ? 0 : 1]
            @state.field.add_cell(Messages::Game::Base::Cell.new(playerId: player.playerId, armySize: rand(8) + 1 ))
          end
        end

        def make_move(player_id, from_cell_id, to_cell_id)
          from_cell = @state.field.get_cell_by_id(from_cell_id)
          to_cell   = @state.field.get_cell_by_id(to_cell_id)

          if from_cell.playerId != player_id
            p "NOT ALLOWED MOVE - YOU ARE TRYING TO MOVE OPPONETS CELL"
            return
          end

          if to_cell.playerId == player_id
            p "NOT ALLOWED MOVE - YOU ARE TRYING TO MOVE TO YOUR OWN CELL"
            return
          end

          to_cell.playerId = from_cell.playerId

          @state.players.players.each do |p|
            self.to(p.connection).update_cell(from_cell)
            self.to(p.connection).update_cell(to_cell)
          end

        end

      end

    end
  end
end
