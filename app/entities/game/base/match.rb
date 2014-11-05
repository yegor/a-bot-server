module Entities
  module Game
    module Base

      class Match

        include ::Phoenix::Entity::Base

        presence :global

        #  Client-side methods available through this entity:
        #
        #  update_cell( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours ) cell )
        #  switch_turn( Entities::Game::Base::Player player )
        #

        def initialize
          @state = Messages::Game::Base::MatchState.new(
            field: nil,
            players: Messages::Game::Base::MatchPlayers.new(),
            turn_number: 100,
            turn_player_id: 500,
          )
        end

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours )[] cells ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turn_number, int32 turn_player_id )
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
            @state.field.add_cell(Messages::Game::Base::Cell.new(player_id: player.id, army_size: rand(8) + 1 ))
          end

          hardcoded_edges = {
             0 => [14, 17, 26],
             1 => [40, 41],
             2 => [ 3,  4,  5],
             3 => [ 2,  4,  6,  7],
             4 => [ 2,  3,  5,  6,  7,  8],
             5 => [ 2,  4,  8,  10, 11],
             6 => [ 3,  4,  7,  18],
             7 => [ 4,  3,  6,  8,  18, 20],
             8 => [ 5,  4,  7,  10, 19, 20],
             9 => [14, 10, 21],
            10 => [ 9, 14, 13, ],
            11 => [11,  5,  8, 19, 21],
            12 => [15, 13, 11],
            13 => [12, 15, 17, 14, 10, 11],
            14 => [0,17,13,10,9],
            15 => [16,17,13,12],
            16 => [23,24,17,15],
            17 => [],
            18 => [],
            19 => [],
            20 => [],
            21 => [],
            22 => [],
            23 => [],
            24 => [],
            25 => [],
            26 => [],
            27 => [],
            28 => [],
            29 => [],
            30 => [],
            31 => [],
            32 => [],
            33 => [],
            34 => [],
            35 => [],
            36 => [],
            37 => [],
            38 => [],
            39 => [],
            40 => [],
            41 => [],
            42 => [],
            43 => [],

          }

          hardcoded_edges.each do |key, value|
            value.each do |x|
              @state.field.cells[key].neighbours << @state.field.cells[x].id
            end
          end

        end

        def make_move(player_id, from_cell_id, to_cell_id)
          from_cell = @state.field.get_cell_by_id(from_cell_id)
          to_cell   = @state.field.get_cell_by_id(to_cell_id)

          if from_cell.player_id != player_id
            p "NOT ALLOWED MOVE - YOU ARE TRYING TO MOVE OPPONETS CELL"
            return
          end

          if to_cell.player_id == player_id
            p "NOT ALLOWED MOVE - YOU ARE TRYING TO MOVE TO YOUR OWN CELL"
            return
          end

          to_cell.player_id = from_cell.player_id

          @state.players.players.each do |p|
            self.to(p.connection).update_cell(from_cell)
            self.to(p.connection).update_cell(to_cell)
          end

        end

      end

    end
  end
end
