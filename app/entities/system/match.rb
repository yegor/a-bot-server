module Entities
  module System

    class Match

      include ::Phoenix::Entity::Base

      presence :global

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


    end

  end
end
