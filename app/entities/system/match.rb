module Entities
  module System

    #  Client-side methods available through this entity:
    #
    #  update_cell( Entities::System::Cell( int32 index, int32 player, int32 armySize ) cell )
    #  update_cell( Entities::System::Cell( int32 index, int32 player, int32 armySize ) cell )
    #
    class Match

      include ::Phoenix::Entity::Base

      presence :global

      def entity_id
        @entity_id ||= Celluloid.uuid
      end

      def initialize
        p "INITIALIZING MATCH"
        @connections = Set.new
        @state = { cells: [
          { index: 0,  player: 1, armySize: 1},
          { index: 1,  player: 1, armySize: 2},
          { index: 2,  player: 1, armySize: 7},
          { index: 3,  player: 1, armySize: 1},
          { index: 4,  player: 1, armySize: 6},
          { index: 5,  player: 1, armySize: 1},
          { index: 6,  player: 1, armySize: 4},
          { index: 7,  player: 1, armySize: 1},
          { index: 8,  player: 1, armySize: 1},
          { index: 9,  player: 1, armySize: 3},
          { index: 10, player: 1, armySize: 1},
          { index: 11, player: 1, armySize: 2},
          { index: 12, player: 1, armySize: 1},
          { index: 13, player: 1, armySize: 4},
          { index: 14, player: 1, armySize: 1},
          { index: 15, player: 1, armySize: 2},
          { index: 16, player: 1, armySize: 4},
          { index: 17, player: 1, armySize: 4},
          { index: 18, player: 1, armySize: 1},
          { index: 19, player: 1, armySize: 1},
          { index: 20, player: 1, armySize: 1},
          { index: 21, player: 1, armySize: 2},
          { index: 22, player: 1, armySize: 1},
          { index: 23, player: 1, armySize: 4},
          { index: 24, player: 1, armySize: 1},
          { index: 25, player: 1, armySize: 1},
          { index: 26, player: 1, armySize: 2},
          { index: 27, player: 2, armySize: 1},
          { index: 28, player: 2, armySize: 2},
          { index: 29, player: 2, armySize: 1},
          { index: 30, player: 2, armySize: 1},
          { index: 31, player: 2, armySize: 4},
          { index: 32, player: 2, armySize: 5},
          { index: 33, player: 2, armySize: 4},
          { index: 34, player: 2, armySize: 1},
          { index: 35, player: 2, armySize: 1},
          { index: 36, player: 2, armySize: 4},
          { index: 37, player: 2, armySize: 1},
          { index: 38, player: 2, armySize: 1},
          { index: 39, player: 2, armySize: 1},
          { index: 40, player: 2, armySize: 1},
          { index: 41, player: 2, armySize: 1},
          { index: 42, player: 2, armySize: 1},
          { index: 43, player: 2, armySize: 1},
        ]}
      end

      #  Result is:
      #    int32
      #
      def get_my_id
        raise NotImplementedError.new
      end

      #  Result is:
      #    Entities::System::MatchState( Entities::System::Cell( int32 index, int32 player, int32 armySize )[] cells )
      #
      def get_state
        @connections.add(Fiber.current[:context][:connection])
        return @state
      end

      #  Arguments are:
      #    from: int32
      #    to: int32
      #
      #  Result is:
      #    (void)
      #
      def make_move( from, to )
        p "MAKING MOVE #{from} -> #{to}"

        from_cell = @state[:cells].detect { |cell| cell[:index] == from }
        to_cell   = @state[:cells].detect { |cell| cell[:index] == to   }

        to_cell[:player] = from_cell[:player]

        @connections.each do |c|
          self.to(c).update_cell(
            Entities::System::Cell.new(index: to, player: to_cell[:player], armySize: to_cell[:armySize])
          )
        end
      end

    end

  end
end
