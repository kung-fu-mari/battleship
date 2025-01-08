require './lib/ship'
require './lib/board'

def start
  play = true
  while play
    puts "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    print "> "
    answer = gets.chomp
    puts
  
    if answer == "p" or answer == "P"
      create_boards
      
      create_ships 
      $player_cruiser = Ship.new("Cruiser", 3)
      $player_sub = Ship.new("Submarine", 2)

      $enemy_cruiser = Ship.new("Cruiser", 3)
      $enemy_sub = Ship.new("Submarine", 2)
    
      setup
    else
      play = false
      puts "Thanks for playing!"
    end
  end
end

def create_ships
  valid = false
  while not valid
    puts "Please enter how many ships you want to play with."
    puts "Keep in mind they will all have to fit\nthe dimensions of the board!"
    print "> "
    ship_num = gets.chomp.to_i
  end
end

def create_boards
  puts "Please enter the width of the game board."
  puts "It must be a whole number greater than or equal to 3."
  print "> "
  width = gets.chomp.to_i 
  while width < 3
    puts "That number is too small."
    puts "Please enter a whole number greater than or equal to 3."
    print "> "
    width = gets.chomp.to_i 
  end

  puts "\n"
      
  puts "Please enter the height of the game board."
  puts "(same rules as above)"
  print "> "
  len = gets.chomp.to_i 
  while len < 3
    puts "That number is too small."
    puts "Please enter a whole number greater than or equal to 3."
    print "> "
    len = gets.chomp.to_i 
  end

  puts "\n"
  
  $player_board = Board.new(width, len)
  $enemy_board = Board.new(width, len)
end

def setup
  place_enemy_ship($enemy_cruiser, $enemy_board)
  place_enemy_ship($enemy_sub, $enemy_board)
   
  puts "I have laid out my ships on the grid."
  puts "You now need to lay out your two ships."
  puts "The Cruiser is three units long and the Submarine is two units long."
  puts 
  $player_board.render
  puts "\nEnter the squares for the Cruiser (3 spaces): "
  print "> "
  coords = gets.chomp.split
  
  while not $player_board.valid_placement?($player_cruiser, coords)
    puts "Those are invalid coordinates. Please try again: "
    print "> "
    coords = gets.chomp.split
  end
  puts
  place_ship($player_cruiser, coords, $player_board)
  
  $player_board.render(true)
  puts
  puts "Enter the squares for the Submarine (2 spaces): "
  print "> "
  coords = gets.chomp.split 

  while not $player_board.valid_placement?($player_sub, coords)
    puts "Those are invalid coordinates. Please try again: "
    print "> "
    coords = gets.chomp.split 
  end
  place_ship($player_sub, coords, $player_board)

  gameplay
end

def place_enemy_ship(ship, board)
  ship_placed = false
  coordinates = []

  while not ship_placed do 
    # place cruiser
    start_coordinate = board.cells.keys.sample

    letter = start_coordinate[0]
    number = start_coordinate[1]

    orientation = rand(2)
    
    #horiz
    if orientation == 0
      coordinates = (number..(number.to_i + ship.length - 1).to_s).to_a
      coordinates.map! { |c| letter + c } 
    # vert
    elsif orientation == 1
      target_letter = (letter.ord + ship.length - 1).chr
      coordinates = (letter..target_letter).to_a
      coordinates.map! { |c| c + number } 
    end    
    ship_placed = board.valid_placement?(ship, coordinates) 
  end
  coordinates.each { |c| board.cells[c].place_ship(ship) }
end

def place_ship(ship, coords, board)
  coords.each { |c| board.cells[c].place_ship(ship) }
end

def gameplay
  game = true 
  while game
    puts "=============COMPUTER BOARD============="
    $enemy_board.render
    puts "==============PLAYER BOARD=============="
    $player_board.render(true)
    puts

    player_fire
    enemy_fire

    if $enemy_cruiser.sunk? and $enemy_sub.sunk?
      puts "You win!"
      puts
      puts "Returning to main menu..."
      puts
      game = false
    elsif $player_cruiser.sunk? and $player_sub.sunk?
      puts "I win!"
      puts
      puts "Returning to main menu..."
      puts
      game = false
    end  
  end
end

def player_fire
  puts "Enter the coordinate for your shot: "
  print "> "
  coord = gets.chomp
  valid = false
  while not valid
    while not $enemy_board.cells.keys.include?(coord) and $enemy_board
      puts "Please enter a valid coordinate: "
      print "> "
      coord = gets.chomp
    end

    if $enemy_board.cells[coord].fired_upon? == true 
      coord = ""
    else
      valid = true
    end
  end

  puts

  $enemy_board.cells[coord].fire_upon
  
  if $enemy_board.cells[coord].ship != nil 
    puts "Your shot on #{coord} was a hit!"
    if $enemy_board.cells[coord].ship.sunk?
      puts "You sunk my #{$enemy_board.cells[coord].ship.name}!"
    end
  else
    puts "Your shot on #{coord} was a miss."
  end
  puts
end

def enemy_fire
  coord = $player_board.cells.keys.sample

  while $player_board.cells[coord].fired_upon? == true 
    coord = $player_board.cells.keys.sample
  end
  
  $player_board.cells[coord].fire_upon

  if $player_board.cells[coord].ship != nil 
    puts "My shot on #{coord} was a hit!"
    if $player_board.cells[coord].ship.sunk?
      puts "I sank your #{$player_board.cells[coord].ship.name}!"
    end
  else
    puts "My shot on #{coord} was a miss."
  end
  puts

end

start

