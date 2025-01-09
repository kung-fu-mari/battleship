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
      setup
    else
      play = false
      puts "Thanks for playing!"
    end
  end
end

def create_ships

  ship_num = 0
  ship_num_valid = false
  while not ship_num_valid 
    puts "Please enter how many ships you want to play with."
    puts "Keep in mind they will all have to fit\nthe dimensions of the board!"
    print "> "
    ship_num = gets.chomp.to_i
    if ship_num < 1
      puts "You must play with at least one ship." 
    elsif ship_num > ($player_board.width) * $player_board.height 
      puts "That many ships cannot fit on the board."
    else
      ship_num_valid = true
    end
  end

  done = false
  while not done
    $player_ships = {}
    $enemy_ships = {} 

    ship_num.times do |num|

      puts "Please enter data for ship #{num + 1}:"    
      print "\tName (make this unique): "
      name = gets.chomp
      print "\tLength: "
      len = gets.chomp.to_i

      $player_ships[name] = Ship.new(name, len)
      $enemy_ships[name] = Ship.new(name, len)
    end

    puts
    puts "Here are the ships:"

    $player_ships.values.each do |ship|
      puts "Name: #{ship.name}, Length: #{ship.length}"  
    end

    puts
    puts "Do you want to play with these ships (Y n)?"
    print "> " 
    answer = gets.chomp
    if answer != "n" 
      done = true
    end
    puts
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

  $enemy_ships.values.each do |ship|
    place_enemy_ship(ship, $enemy_board)
  end
   
  puts "I have laid out my ships on the grid."
  puts "You now need to lay out your ships."
  $player_board.render(true)

  $player_ships.values.each do |ship|

    puts "\nEnter the squares for the #{ship.name} (#{ship.length} spaces): "
    print "> "
    coords = gets.chomp.split
  
    while not $player_board.valid_placement?(ship, coords)
      puts "Those are invalid coordinates. Please try again: "
      print "> "
      coords = gets.chomp.split
    end
    puts
    place_ship(ship, coords, $player_board)
  
    $player_board.render(true)
    puts

  end

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

    if $enemy_ships.values.all? { |ship| ship.sunk? }
      puts "You win!"
      puts
      puts "Returning to main menu..."
      puts
      game = false
    elsif $player_ships.values.all? { |ship| ship.sunk? }
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

