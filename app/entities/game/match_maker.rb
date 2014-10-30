module Entities
  module Game

    class MatchMaker

      include ::Phoenix::Entity::Base

      presence :global

      #  Client-side methods available through this entity:
      #
      #  match_ready( Entities::Game::Base::Player player )
      #  match_ready( Entities::Game::Base::Player player )
      #

      #  Result is:
      #    (void)
      #
      def find_match
        raise NotImplementedError.new
      end


    end

  end
end
