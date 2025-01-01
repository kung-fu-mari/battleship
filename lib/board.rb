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
    (@cells.keys).include?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    if not coordinates.all? { |c| valid_coordinate? c }
      return false
    end

    letters = coordinates.map {|x| x[0]} 
    numbers = coordinates.map {|x| x[1]} 
    if ship.length != coordinates.length
      return false
    end
    # letters are all different
    if letters == letters.uniq
      letter_range = ((letters.first)..(letters.last)).to_a
      if letter_range == []
        return false
      elsif letter_range != letters 
        return false
      end

      if not numbers.all? {|x| x == numbers[0]}
        return false
      end
    # letters are all the same
    elsif letters.all? {|x| x == letters[0]}
      number_range = ((numbers.first)..(numbers.last)).to_a
      if number_range == []
       return false
      elsif number_range != numbers 
       return false
      end
 
    else
      return false
    end

    return true
  end

end
