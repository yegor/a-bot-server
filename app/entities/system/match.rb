module Entities
  module System

    #  Client-side methods available through this entity:
    #
    #  move_from_server( string move )
    #  move_from_server( string move )
    #
    class Match

      include ::Phoenix::Entity::Base

      presence :global

      def initialize
        @ololo = 10
        @state = { cells: [
          { index: 0,  player: 1, strength: 1},
          { index: 1,  player: 1, strength: 2},
          { index: 2,  player: 1, strength: 5},
          { index: 3,  player: 1, strength: 1},
          { index: 4,  player: 1, strength: 1},
          { index: 5,  player: 1, strength: 1},
          { index: 6,  player: 1, strength: 4},
          { index: 7,  player: 1, strength: 1},
          { index: 8,  player: 1, strength: 1},
          { index: 9,  player: 1, strength: 1},
          { index: 10, player: 1, strength: 1},
          { index: 11, player: 1, strength: 2},
          { index: 12, player: 1, strength: 1},
          { index: 13, player: 1, strength: 4},
          { index: 14, player: 1, strength: 1},
          { index: 15, player: 1, strength: 2},
          { index: 16, player: 1, strength: 5},
          { index: 17, player: 1, strength: 4},
          { index: 18, player: 1, strength: 1},
          { index: 19, player: 1, strength: 1},
          { index: 20, player: 1, strength: 1},
          { index: 21, player: 1, strength: 2},
          { index: 22, player: 1, strength: 1},
          { index: 23, player: 1, strength: 4},
          { index: 24, player: 1, strength: 1},
          { index: 25, player: 1, strength: 1},
          { index: 26, player: 1, strength: 2},
          { index: 27, player: 1, strength: 1},
          { index: 28, player: 1, strength: 2},
          { index: 29, player: 1, strength: 1},
          { index: 30, player: 1, strength: 1},
          { index: 31, player: 1, strength: 4},
          { index: 32, player: 1, strength: 4},
          { index: 33, player: 1, strength: 4},
          { index: 34, player: 1, strength: 1},
          { index: 35, player: 1, strength: 1},
          { index: 36, player: 1, strength: 4},
          { index: 37, player: 1, strength: 1},
          { index: 38, player: 1, strength: 1},
          { index: 39, player: 1, strength: 1},
          { index: 40, player: 1, strength: 1},
          { index: 41, player: 1, strength: 1},
          { index: 42, player: 1, strength: 1},
          { index: 43, player: 1, strength: 1},
        ]}
      end

      #  Result is:
      #    int32
      #
      def get_my_id
        raise NotImplementedError.new
      end

      #  Result is:
      #    Entities::System::MatchState( Entities::System::Cell( int32 index, int32 player, int32 strength )[] cells )
      #
      def get_state
        @state
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
        self.to(Fiber.current[:context][:connection]).update_cell(@ololo, 5)
        @ololo = @ololo + 1
      end

    end

  end
end
