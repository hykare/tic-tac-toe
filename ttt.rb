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

  # position formatted as string 3b 1c etc.
  # should the translation from 2b -> [row][col] format be somewhere else?
  def update(position, player)
    row = position[0].to_i - 1
    col = position[1].tr('abc', '012').to_i
    @state[row][col] = player.mark
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

def get_move_position
  move = ''
  loop do
    puts 'make a move'
    move = gets.chomp
    move_valid = move =~ /[123][abc]/
    break if move_valid
  end
  move
end

game_board = Board.new
current_player = CurrentPlayer.new

condition = true
while condition
  system 'clear'
  game_board.draw
  position = get_move_position
  game_board.update(position, current_player)
  current_player.switch
end

# TODO
# check for win
# check if board full - tie
# reject taken positions