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

        def add_cell(cell)
          cell.id = 100 * (cells.size + 1)
          cells << cell
        end

        def get_cell_by_id(id)
          cells.detect { |x| x.id == id }
        end

      end

    end
  end
end
