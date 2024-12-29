class Cell
  attr_reader :coordinate,
              :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def render(show_ship = false)
    if @ship == nil 
      return "."
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
