class Board
  def initialize
    @state = Array.new(3) { Array.new(3, ' ') }
  end

  def draw
    system 'clear'
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
    win_message = "#{player.mark} won!\n\n"
    tie_message = "It's a tie!\n\n"
    # horizontal
    @state.each do |row|
      return win_message if row.all? { |mark| mark == player.mark }
    end
    # vertical
    (0..2).each do |column|
      return win_message if @state.all? { |row| row[column] == player.mark }
    end
    # diagonals
    return win_message if @state[0][0] == player.mark && @state[1][1] == player.mark && @state[2][2] == player.mark
    return win_message if @state[0][2] == player.mark && @state[1][1] == player.mark && @state[2][0] == player.mark

    return 'undetermined' if @state.any? { |row| row.any? { |mark| mark == ' ' } }

    tie_message
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
    input = '99' if input.size < 2
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
  puts 'Make a move (1b, 3a etc.)'
  position_free = true
  format_valid = true
  move = ''
  loop do
    puts "Invalid format, make a move formatted as 1a, 2c etc." if !format_valid
    puts "That position is taken! Pick an empty spot" if !position_free

    input = gets.chomp
    move = Move.new(input)
    format_valid = move.valid?
    next unless format_valid
    position_free = game_board.cell_free?(move)
    break if format_valid && position_free
  end
  move
end

game_board = Board.new
current_player = CurrentPlayer.new

game_on = true
while game_on
  game_board.draw
  current_player.switch
  move = get_valid_move(game_board)
  game_board.update(move, current_player)

  next if game_board.check_match_result(current_player) == 'undetermined'

  game_board.draw
  puts game_board.check_match_result(current_player)
  puts 'do you want to play again? y/n'
  answer = gets.chomp
  if answer == 'y'
    game_board.clear # can I reassign game_board to a new object and just ignore the old one?
    current_player.mark = 'x'
  else
    puts 'Thanks for playing!'
    game_on = false
  end

end
