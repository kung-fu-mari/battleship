require './lib/ship'
require './lib/cell'

RSpec.describe do
  before :each do
    cell = Cell.new("B4")
  end

  it 'has placement data' do
    expect(cell.coordinate).to eq("B4")
    expect(cell.ship).to eq(nil)
    expect(cell.empty?).to eq(true)
  end

  it 'can hold a ship segment' do
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    expect(cell.ship).to eq(cruiser)
    expect(cell.empty?).to eq(false)
  end
  
end
