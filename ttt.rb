class Board
  def initialize
    @state = Array.new(3) { Array.new(3, ' ') }
  end

  def draw
    @state.each do |row|
      print row
      puts ''
      puts ''
    end
  end

  def update(row, col, player)
    @state[row - 1][col - 1] = player.mark
  end
end

class CurrentPlayer
  attr_reader :mark

  def initialize
    @mark = 'x'
  end

  def switch
    @mark = mark == 'x' ? 'o' : 'x'
  end
end

game_board = Board.new
current_player = CurrentPlayer.new

condition = true
while condition
  system 'clear'
  game_board.draw
  puts 'make a move'
  print 'row: '
  move_row = gets.chomp.to_i
  print 'column: '
  move_col = gets.chomp.to_i
  game_board.update(move_row, move_col, current_player)
  current_player.switch
end
