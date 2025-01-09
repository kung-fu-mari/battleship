require './lib/cell'

class Board
  attr_reader :cells,
              :width,
              :height

  def initialize(width = 4, height = 4)
      if width < 3
        width = 3
      end

      if height < 3
        height = 3
      end

      @width = width
      @height = height
      
      @cells = {}
      construct_cells
  end

  def construct_cells
    target_letter = ("A".ord + @height - 1).chr
    letters = ("A"..target_letter).to_a
    @height.times do |num_1|
      letter = letters[num_1]
      @width.times do |num|
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

    if coordinates.any? {|c| @cells[c].ship != nil}
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

  def render(show_ships = false)
    nums = ("1".."#{@width}").to_a
    header_string = " "
    nums.each do |num|
      header_string += " #{num}" 
    end
    puts header_string
    last_letter = ("A".ord + @height - 1).chr

    letters = ("A"..last_letter).to_a
    letters.each do |letter|
      print "#{letter} "
      @width.times do |num|
        key_string = "#{letter}#{num + 1}"
        print "#{@cells[key_string].render(show_ships)} "
      end
      puts
    end
  end
end
