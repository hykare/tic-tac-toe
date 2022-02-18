class Board
  def initialize
    @state = Array.new(3) { Array.new(3, ' ') }
  end

  def draw
    puts '    a    b    c'
    @state.each_with_index do |row, i|
      print "#{i + 1} "
      print row
      puts ''
      puts ''
    end
  end

  # position formatted as string 3b 1c etc.
  def update(move, player)
    @state[move.row][move.col] = player.mark
  end

  def clear
    @state.each do |row|
      row.fill(' ')
    end
  end

  # this could only check current player marks if it's run after a valid move
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

  def cell_free?(move)
    @state[move.row][move.col] == ' '
  end
end

class CurrentPlayer
  attr_accessor :mark # can be reader if a new object is made for a new game

  def initialize
    @mark = 'x'
  end

  def switch
    @mark = mark == 'x' ? 'o' : 'x'
  end
end

class Move
  attr_reader :row, :col

  def initialize(input)
    # incorrect values get stored as 9
    @row = input[0].tr('^123', '9').tr('123', '012').to_i
    @col = input[1].tr('^abc', '9').tr('abc', '012').to_i
  end

  def valid?
    @row.between?(0, 2) && @col.between?(0, 2)
  end
end

# this should probably belong to some class
def get_valid_move(game_board)
  move = ''
  loop do
    puts 'make a move (1b, 3a etc.)'
    input = gets.chomp
    move = Move.new(input)
    move_valid = move.valid? && game_board.cell_free?(move)
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

  move = get_valid_move(game_board)
  game_board.update(move, current_player)
  current_player.switch

  next if game_board.check_match_result == 'undetermined'

  puts game_board.check_match_result
  puts 'do you want to play again? y/n'
  answer = gets.chomp
  if answer == 'y'
    game_board.clear # can I reassign game_board to a new object and just ignore the old one?
    current_player.mark = 'x' # needs a setter/ attr.writer
  else
    puts 'Thanks for playing!'
    condition = false
  end

end

# TODO
# fix markers/free cells so they're not strings
# fix match results so they're not strings
# rewrite match result method, it's ugly
# organize getting input/validation into functions
# put position, translation, getting input into a class somehow?
# confusing names, move/position. input_move, valid_move? input_position?
# redraw the board when match is finished, the last move doesn't show up
# game treats every key other then y as no, change it to do nothing unless its n? another loop?
# putting things into functions - need to be passed all of the relevant objects ?

# CURRENT
# reset to play another game or exit once the game result is determined