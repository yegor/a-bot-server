module Messages
  module Game
    module Base

      class MatchState

        include ::Phoenix::Messages::Base

        #  Fields defined on this message:
        #
        #  field: Messages::Game::Base::Field( Messages::Game::Base::Cell( int32 id, int32 player_id, int32 army_size )[] cells, Messages::Game::Base::Node( int32 from, int32 to )[] nodes )
        #  players: Messages::Game::Base::MatchPlayers( Entities::Game::Base::Player[] players )
        #  turn_number: int32
        #  turn_player_id: int32
        #


      end

    end
  end
end
