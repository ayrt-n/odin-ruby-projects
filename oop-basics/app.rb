require './tic_tac_board'

game = TicTacBoard.new

loop do
  game.print_board

  puts "Player #{player_turn} Turn: Select Spot (X, Y)"
  print "X: "
  x = gets.chomp.to_i
  print "Y: "
  y = gets.chomp.to_i

  game.player_selection(x, y, player_turn)
  break if game.draw_game? || game.win_game?
  player_turn == "X" ? player_turn = "O" : player_turn = "X"
end


