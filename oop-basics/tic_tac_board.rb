module MatrixHelpers
  def diagonals(board)
    d1 = []
    d2 = []
    (0..2).each { |element| d1 << board[element][element] }
    (0..2).each { |element| d2 << board[element][2 - element] }
    [d1, d2]
  end

  def columns(board)
    col_array = [[], [], []]
    (0..2).each do |col|
      (0..2).each { |row| col_array[col] << board[row][col] }
    end
    col_array
  end
end

class TicTacBoard
  include MatrixHelpers

  def initialize
    @board = [
      [" ", " ", " "],
      [" ", " ", " "],
      [" ", " ", " "]
    ]
  end

  def print_board
    puts ""
    puts "\s \s [0] \s[1] \s[2]"
    (0..2).each do |row|
      print [row]
      print board[row]
      puts ""
    end
    puts ""
  end

  def win_game?
    # Check left to right win
    board.each do |row|
      return true if row.all?("X") || row.all?("O")
    end

    # Check top to bottom win
    columns(board).each do |col|
      return true if col.all?("X") || col.all?("O")
    end

    # Check diagonal win
    diagonals(board).each do |diag|
      return true if diag.all?("X") || diag.all?("O")
    end

    false
  end
  
  def draw_game?
    # Draw game when all the rows contain no blank spaces
    board.all? do |row|
      row.none? { |e| e == " " }
    end
  end
  
  def empty_space?(x, y)
    board[y][x] == " "
  end

  def player_selection(x, y, player)
    self.board[y][x] = player
  end

  protected
  attr_accessor :board

end

