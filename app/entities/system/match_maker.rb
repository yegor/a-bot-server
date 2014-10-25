module Entities
  module System

    class MatchMaker

      include ::Phoenix::Entity::Base

      presence :global

      def initialize
        p "INITIALIZING MATCH MAKER"
      end

      #  Result is:
      #    Entities::System::Match
      #
      def create_match
        Entities::System::Match.new
      end


    end

  end
end
