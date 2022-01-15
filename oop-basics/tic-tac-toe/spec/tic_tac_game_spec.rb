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
    context 'when player wins game' do
      let(:incomplete_board) { instance_double(TicTacBoard) }
      let(:incomplete_game) { described_class.new('p1', 'p2', incomplete_board) }

      before do
        allow(incomplete_game).to receive(:puts)
        allow(incomplete_board).to receive(:print_board)
        allow(incomplete_game).to receive(:prompt_player_selection).and_return([0, 0])
        allow(incomplete_board).to receive(:player_selection)
        allow(incomplete_board).to receive(:win_game?).and_return(true)
        allow(incomplete_board).to receive(:draw_game?).and_return(false)
      end

      it 'sends print_board to incomplete_board' do
        expect(incomplete_board).to receive(:print_board)
        incomplete_game.play
      end
    end
  end
end
