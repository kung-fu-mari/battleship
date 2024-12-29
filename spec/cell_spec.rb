require './lib/ship'
require './lib/cell'

RSpec.describe Cell do
  it 'has placement data' do
    cell = Cell.new("B4")
    expect(cell.coordinate).to eq("B4")
    expect(cell.ship).to eq(nil)
    expect(cell.empty?).to eq(true)
  end

  it 'can hold a ship segment' do
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    expect(cell.ship).to eq(cruiser)
    expect(cell.empty?).to eq(false)
  end
  
  it 'damages its ship when it is fired upon' do
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    expect(cell.fired_upon?).to eq(false)
    cell.fire_upon
    expect(cell.ship.health).to eq(2)
    expect(cell.fired_upon?).to eq(true)
  end 

  it 'renders itself' do
    cell_1 = Cell.new("B4")
    expect(cell_1.render).to eq(".")
    cell_1.fire_upon
    # M for missed shot; no ship
    expect(cell_1.render).to eq("M")

    cell_2 = Cell.new("C3")
    cruiser = Ship.new("Cruiser", 3)
    cell_2.place_ship(cruiser)
    # ship is hidden by default
    expect(cell_2.render).to eq(".")
    # passing true to render shows (S)hip if present
    expect(cell_2.render(true)).to eq("S")
    cell_2.fire_upon
    # if a ship is (H)it, it is shown automatically
    expect(cell_2.render).to eq("H")
    expect(cruiser.sunk?).to eq(false)

    # When a ship has been sunk, we show an X
    cruiser.hit
    cruiser.hit
    expect(cruiser.sunk?).to eq(true)
    expect(cell_2.render).to eq("X")
  end
end
