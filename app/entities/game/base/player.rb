module Entities
  module Game
    module Base

      class Player

        include ::Phoenix::Entity::Base

        presence :global

        attr_accessor :account

        def initialize(account)
          self.account = account
        end

        #  Arguments are:
        #    from: int32
        #    to: int32
        #
        #  Result is:
        #    (void)
        #
        def make_move( from, to )
          raise NotImplementedError.new
        end

        #  Result is:
        #    (void)
        #
        def end_turn
          raise NotImplementedError.new
        end

      end

    end
  end
end
