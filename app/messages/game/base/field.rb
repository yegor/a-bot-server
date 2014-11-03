module Messages
  module Game
    module Base

      class Field

        include ::Phoenix::Messages::Base

        #  Fields defined on this message:
        #
        #  cells: Messages::Game::Base::Cell( int32 id, int32 playerId, int32 armySize )[]
        #  nodes: Messages::Game::Base::Node( int32 from, int32 to )[]
        #


      end

    end
  end
end
