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

  def check_match_result
    # horizontal
    @state.each do |row|
      return 'o_won' if row.all? { |mark| mark == 'o' }
      return 'x_won' if row.all? { |mark| mark == 'x' }
    end
    # vertical
    (0..2).each do |i|
      return 'o_won' if @state.all? { |row| row[i] == 'o' }
      return 'x_won' if @state.all? { |row| row[i] == 'x' }
    end
    # diagonals
    return 'o_won' if @state[0][0] == 'o' && @state[1][1] == 'o' && @state[2][2] == 'o'
    return 'o_won' if @state[0][2] == 'o' && @state[1][1] == 'o' && @state[2][0] == 'o'
    return 'x_won' if @state[0][0] == 'x' && @state[1][1] == 'x' && @state[2][2] == 'x'
    return 'x_won' if @state[0][2] == 'x' && @state[1][1] == 'x' && @state[2][0] == 'x'

    return 'undetermined' if @state.any? { |row| row.any? { |mark| mark == ' ' } }

    'tie'
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
  puts "match result: #{game_board.check_match_result}"
  game_board.draw
  position = get_move_position
  game_board.update(position, current_player)
  current_player.switch

end

# TODO
# reject taken positions
# fix markers so they're not strings
# fix match results so they're not strings
