module Entities
  module Game
    module Base

      class Player

        include ::Phoenix::Entity::Base

        #  Properties defined on this entity (will be sent to clients):
        #
        #  id: int32
        #
        
        presence :global

        attr_accessor :account
        attr_accessor :match

        def initialize(account, match)
          self.account = account
          self.match = match
        end

        #  Arguments are:
        #    from: int32
        #    to: int32
        #
        #  Result is:
        #    (void)
        #
        def make_move(from, to)
          match.make_move(self.id, from, to)
        end

        #  Result is:
        #    (void)
        #
        def end_turn
          match.end_turn
        end

        def connection
          return self.account.connection
        end

      end

    end
  end
end
