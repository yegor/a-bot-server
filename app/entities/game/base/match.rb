module Entities
  module Game
    module Base

      class Match

        include ::Phoenix::Entity::Base

        presence :global

        attr_accessor :state

        #  Client-side methods available through this entity:
        #
        #  update_cell( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours ) cell )
        #  switch_turn( Entities::Game::Base::Player player )
        #

        def initialize
          self.state = Messages::Game::Base::MatchState.new(
            field: nil,
            players: Messages::Game::Base::MatchPlayers.new(),
            turn_number: 0,
            turn_player_id: 0,
          )
        end

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours )[] cells ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turn_number, int32 turn_player_id )
        #
        def get_state
          return state
        end

        #  Adds a player to the match.
        #
        def add_player(player)
          state.players.add_player(player)
        end

        def generate_field
          state.field = Messages::Game::Base::Field.new()

          44.times do |x|
            player = state.players.players.sample
            state.field.add_cell(Messages::Game::Base::Cell.new(player_id: player.id, army_size: rand(8) + 1 ))
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
            14 => [ 0, 17, 13, 10,  9],
            15 => [16, 17, 13, 12],
            16 => [23, 24, 17, 15],
            17 => [16, 15, 13,  0, 26, 25, 24],
            18 => [ 7,  6, 25, 20],
            19 => [10,  8, 20, 19],
            20 => [ 7, 18, 35, 36, 37, 19],
            21 => [ 9, 10, 19, 37, 38, 34],
            22 => [42, 43],
            23 => [27, 24, 16],
            24 => [23, 16, 17, 25, 28, 27],
            25 => [28, 24, 17, 26],
            26 => [31, 25, 17, 0],
            27 => [29, 28, 24, 23],
            28 => [30, 29, 27, 24, 25, 32],
            29 => [27, 28, 30],
            30 => [28, 29, 32, 33],
            31 => [34, 39, 32, 26],
            32 => [31, 39, 40, 41, 33, 30, 28],
            33 => [30, 32, 41],
            34 => [21, 31, 38, 39],
            35 => [18, 20, 36, 42],
            36 => [37, 20, 35, 42],
            37 => [38, 21, 19, 20, 36],
            38 => [39, 34, 21, 37],
            39 => [40, 32, 31, 34, 38],
            40 => [ 1, 41, 32, 39],
            41 => [33, 32, 40,  1],
            42 => [35, 36, 43, 22],
            43 => [42, 22],
          }

          hardcoded_edges.each do |key, value|
            value.each do |x|
              state.field.cells[key].neighbours << state.field.cells[x].id
            end
          end

        end

        #  Result is:
        #    Messages::Geometry::Field( Messages::Geometry::Cell( Messages::Geometry::Mesh( Messages::Geometry::Vertex( float x, float y, float z )[] vertices, Messages::Geometry::Triangle( int32 index0, int32 index1, int32 index2 )[] triangles ) mesh )[] cells )
        #
        def get_field_geometry
          return Messages::Geometry::Field.new
        end

        # Called at match start
        #
        def start
          state.turn_player_id = state.players.players.first.id
          state.turn_number = 1
        end

        # Tiny helper
        #
        def invalid_turn(error_text)
          logger.error "[Turn ##{state.turn_number}] [Invalid turn] #{error_text}"
          return false
        end

        #  Ends turn by picking next player to perform the turn.
        #
        def end_turn(player_id)
          logger.debug "[Turn ##{state.turn_number}] End of turn #{state.turn_number}"

          if state.turn_player_id != player_id
            return invalid_turn "An attempt to end turn from player #{player_id} while current player is #{state.turn_player_id}"
          end

          next_player_index = 1 + state.players.players.index { |player| player.id == state.turn_player_id }

          if next_player_index == state.players.players.size
            grow_armies
            next_player_index = 0
          end

          next_player = state.players.players[next_player_index]
          
          state.turn_player_id = next_player.id
          state.turn_number += 1

          broadcast { |to| to.switch_turn(next_player) }
        end

        # Check if move is valid
        #
        def move_is_valid(from_cell, to_cell)
          if from_cell.player_id != state.turn_player_id
            return invalid_turn "An attempt to move opponent's cell"
          end

          if to_cell.player_id == state.turn_player_id
            return invalid_turn "An attempt to move own cell"
          end

          if not from_cell.neighbours.detect { |id| id == to_cell.id }
            return invalid_turn "An attempt to move to not neighbour cell"
          end

          if from_cell.army_size == 1
            return invalid_turn "An attempt to attack with army size 1"
          end

          return true
        end

        # Retuns true if from_cell succeeded to capture to_cell 
        #
        def victory_conditions(from_cell, to_cell)
          from_score = (1..from_cell.army_size).to_a.map { rand(8) + 1 }.sum
          to_score = (1..to_cell.army_size).to_a.map { rand(8) + 1 }.sum

          logger.debug "[Turn ##{state.turn_number}] #{state.turn_player_id} scored #{from_score} against #{to_score}"

          from_score > to_score
        end

        # Actions performed if attack succeeded
        #
        def attack_succeeded(from_cell, to_cell)
          logger.debug "[Turn ##{state.turn_number}] #{state.turn_player_id} succeeded to capture cell #{to_cell.id}"

          to_cell.player_id = from_cell.player_id
          to_cell.army_size = [from_cell.army_size - 1, 1].max

          from_cell.army_size = 1
        end

        # Actions performed if attack failed
        #
        def attack_failed(from_cell, to_cell)
          logger.debug "[Turn ##{state.turn_number}] #{state.turn_player_id} failed to capture cell #{to_cell.id}"

          from_cell.army_size = 1
        end

        #  Makes a move.
        #
        def make_move(player_id, from_cell_id, to_cell_id)
          logger.debug "[Turn ##{state.turn_number}] #{player_id} wants to move from #{from_cell_id} to #{to_cell_id}"

          if state.turn_player_id != player_id
            return invalid_turn "An attempt to make a move from player #{player_id} while current player is #{state.turn_player_id}"
          end

          from_cell = state.field.get_cell_by_id(from_cell_id)
          to_cell   = state.field.get_cell_by_id(to_cell_id)

          if not move_is_valid(from_cell, to_cell)
            return
          end

          if victory_conditions(from_cell, to_cell)
            attack_succeeded(from_cell, to_cell)
          else
            attack_failed(from_cell, to_cell)
          end

          broadcast do |to|
            to.update_cell(from_cell)
            to.update_cell(to_cell)
          end
        end

        # Grow armies after all players made their moves
        #
        def grow_armies
          logger.debug "[Turn ##{state.turn_number}] Growing armies"

          state.players.players.each do |player|
            state.field.cells.select { |cell| cell.player_id == player.id }.sample(10).each do |cell|
              cell.army_size = [cell.army_size + 1, 8].min

              broadcast { |to| to.update_cell(cell) }
            end
          end
        end

        # Send something to all players
        #
        def broadcast(players = state.players.players, &block)
          players.each do |player|
            yield self.to(player.connection)
          end
        end

      end

    end
  end
end
