module Entities
  module Game
    module Base

      class Match

        include ::Phoenix::Entity::Base

        presence :global

        attr_reader :state

        #  Client-side methods available through this entity:
        #
        #  update_cell( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours ) cell )
        #  switch_turn( Entities::Game::Base::Player player )
        #

        def initialize
          @state = Messages::Game::Base::MatchState.new(
            field: nil,
            players: Messages::Game::Base::MatchPlayers.new(),
            turn_number: 0,
            turn_player_id: 500,
          )
        end

        #  Result is:
        #    Messages::Game::Base::MatchState( Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size, int32[] neighbours )[] cells ) field, Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players ) players, int32 turn_number, int32 turn_player_id )
        #
        def get_state
          return @state
        end

        #  Adds a player to the match.
        #
        def add_player(player)
          state.turn_player_id = player.id
          state.players.add_player(player)
        end

        def generate_field
          state.field = Messages::Game::Base::Field.new()

          44.times do |x|
            player = @state.players.players[x < 22 ? 0 : 1]
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
              state.field.cells[key].neighbours << @state.field.cells[x].id
            end
          end

        end

        #  Ends turn by picking next player to perform the turn.
        #
        def end_turn
          next_player = @state.players.players.detect { |candidate| candidate.id != @state.turn_player_id }
          
          state.turn_player_id = next_player.id
          state.turn_number += 1

          state.players.players.each do |p|
            self.to(p.connection).switch_turn(next_player)
          end
        end

        #  Makes a move.
        #
        def make_move(player_id, from_cell_id, to_cell_id)
          logger.debug "[Turn ##{state.turn_number}] #{player_id} wants to move from #{from_cell_id} to #{to_cell_id}"

          from_cell = @state.field.get_cell_by_id(from_cell_id)
          to_cell   = @state.field.get_cell_by_id(to_cell_id)

          if state.turn_player_id != player_id
            logger.error "[Turn ##{state.turn_number}] [Invalid turn] An attempt to make a move when you aren't current player"
            return
          end

          if from_cell.player_id != player_id
            logger.error "[Turn ##{state.turn_number}] [Invalid turn] An attempt to move opponent's cell"
            return
          end

          if to_cell.player_id == player_id
            logger.error "[Turn ##{state.turn_number}] [Invalid turn] An attempt to move own cell"
            return
          end

          from_score = (1..from_cell.army_size).to_a.map { rand(8) + 1 }.sum
          to_score = (1..to_cell.army_size).to_a.map { rand(8) + 1 }.sum

          logger.debug "[Turn ##{state.turn_number}] #{player_id} scored #{from_score} against #{to_score}"

          if from_score > to_score
            to_cell.player_id = from_cell.player_id
            to_cell.army_size = [from_cell.army_size - 1, 1].max
          end

          from_cell.army_size = 1

          state.players.players.each do |p|
            self.to(p.connection).update_cell(from_cell)
            self.to(p.connection).update_cell(to_cell)
          end
        end

      end

    end
  end
end
