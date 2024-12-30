require './lib/cell'

class Board
  attr_reader :cells

  def initialize
      @cells = {}
      construct_cells
  end

  def construct_cells
    letters = ("A".."D").to_a
    4.times do |num_1|
      letter = letters[num_1]
      4.times do |num|
        s = "#{letter}#{num + 1}"
        cell = Cell.new(s)
        @cells[s] = cell
      end
    end
  end

  def valid_coordinate?(coordinate)

  end

  def valid_placement?(ship, coordinates)

  end

end
