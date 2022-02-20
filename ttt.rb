class Board
  def initialize
    @state = Array.new(3) { Array.new(3, ' ') }
  end

  def draw
    puts '    a   b   c'
    @state.each_with_index do |row, i|
      puts '  -------------'
      print "#{i + 1} "
      row.each do |cell|
        print '|'
        print ' ', cell, ' '
      end
      print '|' # last divider in a row
      puts ''
    end
    puts "  -------------\n\n"
  end

  def update(move, player)
    @state[move.row][move.col] = player.mark
  end

  def clear
    @state.each do |row|
      row.fill(' ')
    end
  end

  # checks only current player marks (has to be in order switch->move->check)
  # should separate game results from messages
  def check_match_result(player)
    win_message = "#{player.mark} won"

    # horizontal
    @state.each do |row|
      return win_message if row.all? { |mark| mark == player.mark }
    end
    # vertical
    (0..2).each do |i|
      return win_message if @state.all? { |row| row[i] == player.mark }
    end
    # diagonals
    return win_message if @state[0][0] == player.mark && @state[1][1] == player.mark && @state[2][2] == player.mark
    return win_message if @state[0][2] == player.mark && @state[1][1] == player.mark && @state[2][0] == player.mark

    return 'undetermined' if @state.any? { |row| row.any? { |mark| mark == ' ' } }

    'tie'
  end

  def cell_free?(move)
    @state[move.row][move.col] == ' '
  end
end

class CurrentPlayer
  attr_accessor :mark # setter is only needed to reset objects after a game

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
  game_board.draw
  current_player.switch
  move = get_valid_move(game_board)
  game_board.update(move, current_player)

  next if game_board.check_match_result(current_player) == 'undetermined'

  puts game_board.check_match_result(current_player)
  puts 'do you want to play again? y/n'
  answer = gets.chomp
  if answer == 'y'
    game_board.clear # can I reassign game_board to a new object and just ignore the old one?
    current_player.mark = 'x'
  else
    puts 'Thanks for playing!'
    condition = false
  end

end
