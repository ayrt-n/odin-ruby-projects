require './lib/tic_tac_game'
require './lib/tic_tac_board'

describe Game do
  describe '#initialize' do
    before do
      allow(TicTacBoard).to receive(:new)
    end

    it 'sends new to TicTacBoard' do
      expect(TicTacBoard).to receive(:new)
      Game.new('p1', 'p2')
    end
  end

  describe '#play' do
    let(:game_board) { instance_double(TicTacBoard) }
    let(:game) { described_class.new('p1', 'p2', game_board) }

    context 'when player wins in current round' do  
      before do
        allow(game).to receive(:puts).and_return('', "\np1 wins! Good game.")
        allow(game_board).to receive(:print_board)
        allow(game).to receive(:prompt_player_selection).and_return([0, 0])
        allow(game_board).to receive(:player_selection)
        allow(game_board).to receive(:win_game?).and_return(true)
        allow(game_board).to receive(:draw_game?).and_return(false)
      end

      it 'sends print_board to game_board' do
        expect(game_board).to receive(:print_board)
        game.play
      end

      it 'sends prompt_player_selection to game' do
        expect(game).to receive(:prompt_player_selection)
        game.play
      end

      it 'sends player_selection to game_board' do
        expect(game_board).to receive(:player_selection)
        game.play
      end

      it 'ends loop after game_board.win_game? returns true' do
        expect(game).to receive(:puts).with("\np1 wins! Good game.").once
        game.play
      end
    end

    context 'when game draw in current round' do
      before do
        allow(game).to receive(:puts).and_return('', "\nDraw game! There was no winner.")
        allow(game_board).to receive(:print_board)
        allow(game).to receive(:prompt_player_selection).and_return([0, 0])
        allow(game_board).to receive(:player_selection)
        allow(game_board).to receive(:win_game?).and_return(false)
        allow(game_board).to receive(:draw_game?).and_return(true)
      end

      it 'ends loop after game_board.draw_game? returns true' do
        expect(game).to receive(:puts).with("\nDraw game! There was no winner.").once
        game.play
      end
    end

    context 'when player wins in 2 rounds' do
      before do
        allow(game).to receive(:puts).and_return('', "\np1 wins! Good game.")
        allow(game_board).to receive(:print_board)
        allow(game).to receive(:prompt_player_selection).and_return([0, 0])
        allow(game_board).to receive(:player_selection)
        allow(game_board).to receive(:win_game?).and_return(false, true)
        allow(game_board).to receive(:draw_game?).and_return(false)
      end

      it 'loops twice before ending' do
        expect(game_board).to receive(:print_board).twice
        game.play
      end

      it 'switches current_marker at end of first loop' do
        marker = game.current_marker
        game.play
        expect(game.current_marker).not_to eql(marker)
      end

      it 'switches current_player at end of first loop' do
        player = game.current_player
        game.play
        expect(game.current_player).not_to eql(player)
      end
    end

    context 'when draw game in 2 rounds' do
      before do
        allow(game).to receive(:puts).and_return('', "\nDraw game! There was no winner.")
        allow(game_board).to receive(:print_board)
        allow(game).to receive(:prompt_player_selection).and_return([0, 0])
        allow(game_board).to receive(:player_selection)
        allow(game_board).to receive(:win_game?).and_return(false)
        allow(game_board).to receive(:draw_game?).and_return(false, true)
      end

      it 'loops twice before ending' do
        expect(game_board).to receive(:print_board).twice
        game.play
      end
    end
  end

  describe '#prompt_player_selection' do
    let(:game_board) { instance_double(TicTacBoard) }
    let(:game) { described_class.new('p1', 'p2', game_board) }

    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:prompt_move).and_return(0)
    end

    context 'when player provides valid input first time' do
      before do
        allow(game_board).to receive(:empty_space?).and_return(true)
      end

      it 'sends prompt_move to game' do
        expect(game).to receive(:prompt_move).twice
        game.send(:prompt_player_selection)
      end

      it 'returns players input' do
        player_input = game.send(:prompt_player_selection)
        expect(player_input).to eql([0, 0])
      end
    end

    context 'when player provides invalid and then valid response' do
      it 'breaks out of loop after player provides valid input' do
        allow(game).to receive(:puts).and_return('', 'Spot is already taken, please try again.')
        allow(game_board).to receive(:empty_space?).and_return(false, true)
        expect(game).to receive(:puts).with('Spot is already taken, please try again.')
        game.send(:prompt_player_selection)
      end
    end
  end

  describe '#prompt_move' do
    let(:game_board) { instance_double(TicTacBoard) }
    let(:game) { described_class.new('p1', 'p2', game_board) }

    before do
      allow(game).to receive(:print)
      allow(game).to receive(:puts)
    end

    it 'returns valid input' do
      allow(game).to receive(:gets).and_return('1')
      player_input = game.send(:prompt_move, '')
      expect(player_input).to eql(1)
    end

    it 'breaks out after receiving invalid and then valid input' do
      allow(game).to receive(:gets).and_return('a', '0')
      expect(game).to receive(:puts).with('Incorrect input: Value must be between 0-2').once
      game.send(:prompt_move, '')
    end
  end
end
