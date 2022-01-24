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

end

game_board = Board.new
game_board.draw
