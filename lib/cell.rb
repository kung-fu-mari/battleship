class Cell
  attr_reader :coordinate,
              :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    if @ship != nil
      @ship.hit
    end
    @fired_upon = true
  end

  def fired_upon?
    @fired_upon
  end

  def render(show_ship = false)
    if @ship == nil 
      if fired_upon?
        return "M"
      else
        return "."
      end
    elsif @ship.sunk?
      return "X"
    elsif @ship.health != @ship.length
      return "H"
    elsif show_ship == true
      return "S"
    end

    return "."
  end
end
