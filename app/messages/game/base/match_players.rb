module Messages
  module Game
    module Base

      class MatchPlayers

        include ::Phoenix::Messages::Base

        #  Fields defined on this message:
        #
        #  players: Entities::Game::Base::Player[]
        #

        def add_player(player)
          player.id = 100 * (players.size + 1)
          self.players += [ player ]
        end

        def get_player_by_id(id)
          self.players.detect { |x| x.id == id }
        end

      end

    end
  end
end
