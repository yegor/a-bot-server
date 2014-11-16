namespace :field do
  task :test do
    field = ::Entities::Game::Base::Match::FieldGenerator.new(50, 25)
    
    17.times { |x| field.add_cell("rgb(0, #{15 * x}, #{255 - 15 * x})") }
    17.times { |x| field.add_cell("rgb(#{15 * x}, #{255 - 15 * x}, 0)") }

    field.save_to_file(0)

    for i in 1..100 do
      field.cells.each do |cell|
        field.expand_cell(cell.index)
      end

      if i % 10 == 0
        field.save_to_file(i)
      end
    end

    field.compute_edges()

    field.cells.each do |cell|
      p cell.neighbours
    end
  end 
end