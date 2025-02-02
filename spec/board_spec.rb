require './lib/board'
require './lib/ship'

RSpec.describe Board do
  it 'stores a dictionary of cells' do
    board = Board.new
    expect(board.cells["A1"]).to be_instance_of(Cell)
  end
  
  it 'can tell if a space is on the board' do
    board = Board.new

    expect(board.valid_coordinate?("A1")).to eq(true)
    expect(board.valid_coordinate?("D4")).to eq(true)
    expect(board.valid_coordinate?("A5")).to eq(false)
    expect(board.valid_coordinate?("E1")).to eq(false)
    expect(board.valid_coordinate?("A22")).to eq(false)
  end


  it "ship length must be same as number of coordinates" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(board.valid_placement?(cruiser, ["A1", "A2"])).to eq(false)
    expect(board.valid_placement?(submarine, ["A2", "A3", "A4"])).to eq(false)
  end

  it "coordinates must be consecutive" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to eq(false)
    expect(board.valid_placement?(submarine, ["A1", "C1"])).to eq(false)
    expect(board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to eq(false)
    expect(board.valid_placement?(submarine, ["C1", "B1"])).to eq(false)
  end

  it "coordinates cannot be diagonal" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to eq(false)
    expect(board.valid_placement?(submarine, ["C2", "D3"])).to eq(false)
  end
    
  it "valid placements" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(board.valid_placement?(submarine, ["A1", "A2"])).to eq(true)
    expect(board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to eq(true)
  end
  
  it "can have varying sizes" do
    # parameters are width, height
    board_1 = Board.new(3,3)
    expect(board_1.cells.length).to eq(9)
    expect(board_1.cells.keys).to eq(["A1", "A2", "A3",
                                     "B1", "B2", "B3",
                                     "C1", "C2", "C3"])
    board_2 = Board.new(5,3)
    expect(board_2.cells.length).to eq(15)
    expect(board_2.cells.keys).to eq(["A1", "A2", "A3", "A4", "A5",
                                     "B1", "B2", "B3", "B4", "B5",
                                     "C1", "C2", "C3", "C4", "C5"])
  end

  it "must be at least 3 units long in both dimensions" do
    expect(Board.new(1,4).cells.keys).to eq(["A1", "A2", "A3",
                                             "B1", "B2", "B3",
                                             "C1", "C2", "C3",
                                             "D1", "D2", "D3"])
  end
end
