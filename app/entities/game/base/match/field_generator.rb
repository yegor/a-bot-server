require 'set'

module Entities
  module Game
    module Base
      class Match

        class Cell
          attr_accessor :color
          attr_accessor :index
          attr_accessor :x
          attr_accessor :y
          attr_accessor :neighbours

          def initialize(index, color, x, y)
            self.color      = color
            self.index      = index
            self.x          = x
            self.y          = y
            self.neighbours = Set.new
          end
        end

        class FieldGenerator
          attr_accessor :width
          attr_accessor :height
          attr_accessor :cells
          attr_accessor :grid

          def initialize(width, height)
            self.width  = width
            self.height = height
            self.cells  = []
            self.grid   = [-1] * width * height
          end

          def add_cell(color)
            cell = Cell.new(cells.size, color, rand(width), rand(height))
            cells << cell
            set_grid_cell_value(cell.x, cell.y, cell.index)
          end

          def set_grid_cell_value(x, y, value)
            grid[x + width * y] = value
          end

          def get_grid_cell_value(x, y)
            return grid[x + width * y]
          end

          def draw_hex(img, center_x, center_y, r, owner)
            color = owner >= 0 ? cells[owner].color : "white"

            points = []

            for i in 0..7 do
              x = center_x + Math.cos(Math::PI / 3.0 * ((i + 0) % 6) + Math::PI / 6.0) * r
              y = center_y + Math.sin(Math::PI / 3.0 * ((i + 0) % 6) + Math::PI / 6.0) * r

              points << [x, y]
            end

            img.polygon points, :stroke => "black", :fill => color
          end

          def save_to_file(index)
            require 'rasem'

            img = Rasem::SVGImage.new(1500, 1000)

            r = 10

            delta_x = r * 2 * Math.sin(Math::PI / 3.0)
            delta_y = r * 3 / 2

            for x in 0..width - 1 do
                for y in 0..height - 1 do
                  offset_x = y % 2 == 0 ? 0.0 : 0.5 * delta_x
                  draw_hex(img, 100 + x * delta_x + offset_x, 100 + y * delta_y, r, get_grid_cell_value(x, y))
                end 
            end

            img.close

            File.open("test#{index}.svg", "w") do |f|
                f << img.output
            end
          end

          def get_cell_neighbours(x, y)
            neighbours = []

            if y % 2 == 1
              neighbours << [x - 1, y + 0]
              neighbours << [x + 0, y - 1]
              neighbours << [x + 0, y + 1]
              neighbours << [x + 1, y - 1]
              neighbours << [x + 1, y + 0]
              neighbours << [x + 1, y + 1]
            else
              neighbours << [x - 1, y - 1]
              neighbours << [x - 1, y + 0]
              neighbours << [x - 1, y + 1]
              neighbours << [x + 0, y - 1]
              neighbours << [x + 0, y + 1]
              neighbours << [x + 1, y + 0]
            end

            return neighbours.select { |x,y| x >= 0 && x < width && y >= 0 && y < height }
          end

          def expand_cell(cell_index)
            candidates = []

            for x in 0..width - 1 do
              for y in 0..height - 1 do
                if get_grid_cell_value(x, y) == cell_index
                  candidates += get_cell_neighbours(x, y)
                end
              end
            end

            candidates = candidates.select { |x, y| get_grid_cell_value(x, y) == -1 }

            p = candidates.sample()
            if p != nil
              grid[p[0] + width * p[1]] = cell_index
            end
          end

          def compute_edges()
            cells.each do |cell|
              neighbours = []

              for x in 0..width - 1 do
                for y in 0..height - 1 do
                  if get_grid_cell_value(x, y) == cell.index
                    neighbours += get_cell_neighbours(x, y)
                  end
                end
              end

              neighbours.each do |x, y|
                cell.neighbours.add(get_grid_cell_value(x, y))
              end

              cell.neighbours = cell.neighbours.to_a
            end
          end
        end
      end
    end
  end
end