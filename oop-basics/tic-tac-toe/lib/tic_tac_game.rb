class Game
  ACCEPTABLE_VALUES = %w[0 1 2]

  attr_reader :current_marker, :current_player, :board

  def initialize(player1, player2, board = TicTacBoard.new)
    @p1 = player1
    @p2 = player2
    @current_marker = 'X'
    @current_player = @p1
    @board = board
  end

  def play
    puts "\n~*~ Ruby Tic-Tac-Toe ~*~"

    loop do
      board.print_board

      # Prompt player for move
      move_coordinates = prompt_player_selection

      # Update the board
      board.player_selection(move_coordinates[0], move_coordinates[1], current_marker)

      # Check for game coniditons
      if board.win_game?
        puts "\n#{@current_player} wins! Good game."
        break
      elsif board.draw_game?
        puts "\nDraw game! There was no winner."
        break
      else
        @current_marker = @current_marker == 'X' ? 'O' : 'X' # Switch current marker
        @current_player = @current_player == @p1 ? @p2 : @p1 # Switch current player
      end
    end
  end

  private

  def prompt_player_selection
    x = ''
    y = ''

    puts "#{current_player}! It's your turn - Select a spot (X, Y)"
    loop do
      x = prompt_move('> X: ')
      y = prompt_move('> Y: ')

      break if board.empty_space?(x, y)

      puts 'Spot is already taken, please try again.'
    end
    [x, y]
  end

  def prompt_move(prompt)
    input = ''
    loop do
      print prompt
      input = gets.chomp

      break if ACCEPTABLE_VALUES.include?(input)

      puts 'Incorrect input: Value must be between 0-2'
    end
    input.to_i
  end
end
