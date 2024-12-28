require './lib/ship'
# test line
RSpec.describe Ship do
  before :each do
    cruiser = Ship.new("Cruiser", 3)
  end

  it 'has attributes' do
    expect(cruiser.name).to eq("Cruiser")
    expect(cruiser.length).to eq(3)
    expect(cruiser.health).to eq(3)
  end

  it 'can be sunk' do
    expect(cruiser.health).to eq(3)
    expect(cruiser.sunk?).to eq(false)

    cruiser.hit
    expect(cruiser.health).to eq(2)

    cruiser.hit
    expect(cruiser.health).to eq(1)
    expect(cruiser.sunk?).to eq(false)

    cruiser.hit
    expect(cruiser.sunk?).to eq(true)
  end 
end
