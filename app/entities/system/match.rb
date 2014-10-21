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
        { cells: [
          { index: 1, player: 1, strength: 1},
          { index: 2, player: 1, strength: 2},
          { index: 3, player: 1, strength: 1},
          { index: 4, player: 1, strength: 2},
          { index: 5, player: 1, strength: 1},
          { index: 6, player: 2, strength: 2},
          { index: 7, player: 2, strength: 1},
          { index: 8, player: 1, strength: 2},
        ]}
      end

      #  Arguments are:
      #    move: string
      #
      #  Result is:
      #    (void)
      #
      def make_move( move )
        p "MAKING MOVE \"#{move}\""
        self.to(Fiber.current[:context][:connection]).move_from_server(move)
      end

    end

  end
end
