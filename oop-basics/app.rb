require './tic_tac_board'
require './player_io'

loop do
  # Initialize variables for game
  game = TicTacBoard.new
  player_turn = 'X'
  x = ''
  y = ''

  puts "\n~*~ Ruby Tic-Tac-Toe ~*~"

  loop do
    game.print_board

    puts "Player #{player_turn} Turn - Select Spot (X, Y)"
    loop do
      x = prompt_move('> X: ')
      y = prompt_move('> Y: ')

      break if game.empty_space?(x, y)

      puts 'Spot is already taken, please try again.'
    end

    game.player_selection(x, y, player_turn)

    if game.win_game?
      puts "\nPlayer #{player_turn} wins! Good game."
      break
    elsif game.draw_game?
      puts "\nDraw game! There was no winner."
      break
    else
      player_turn = player_turn == 'X' ? 'O' : 'X'
    end
  end

  puts "\nWould you like to play again? (Y/N)"
  while (replay = gets.chomp)
    break if replay == 'Y' || replay == 'N'

    puts "\nInvalid response - Would you like to play again? (Y/N)"
  end

  break if replay == 'N'
end
