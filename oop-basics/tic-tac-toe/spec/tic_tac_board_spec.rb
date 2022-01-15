require './lib/tic_tac_board'

describe TicTacBoard do
  describe '#diagonals' do
    it 'returns array with main diagonals from 3x3 array' do
      end_board = TicTacBoard.new([
        ['X', 'O', 'X'],
        ['X', 'X', 'O'],
        ['O', 'X', 'O']
      ])
      diagonals = end_board.diagonals(end_board.board)
      expect(diagonals).to eq([['X', 'X', 'O'], ['X', 'X', 'O']])
    end
  end

  describe '#columns' do
    it 'returns array with columns from 3x3 array' do
      end_board = TicTacBoard.new([
        ['X', 'O', 'X'],
        ['X', 'X', 'O'],
        ['O', 'X', 'O']
      ])
      columns = end_board.columns(end_board.board)
      expect(columns).to eq([['X', 'X', 'O'], ['O', 'X', 'X'], ['X', 'O', 'O']])
    end
  end

  describe '#win_game?' do
    let(:empty_board) { described_class.new }

    before do
      allow(empty_board).to receive(:diagonals).with(empty_board.board).and_return([[' ', ' ', ' '], [' ', ' ', ' ']])
      allow(empty_board).to receive(:columns).with(empty_board.board).and_return([[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']])
    end

    it 'sends board to columns' do
      expect(empty_board).to receive(:diagonals)
      empty_board.win_game?
    end

    it 'sends board to columns' do
      expect(empty_board).to receive(:columns)
      empty_board.win_game?
    end

    context 'when there is no winner' do
      it 'returns false' do
        expect(empty_board).not_to be_win_game
      end
    end

    context 'when winner across a diagonal' do
      it 'returns true' do
        winning_board = TicTacBoard.new([
          ['X', ' ', ' '],
          [' ', 'X', ' '],
          [' ', ' ', 'X']
        ])
        allow(winning_board).to receive(:diagonals).with(winning_board.board).and_return([['X', 'X', 'X'], [' ', 'X', ' ']])
        allow(winning_board).to receive(:columns).with(winning_board.board).and_return([['X', ' ', ' '], [' ', 'X', ' '], [' ', ' ', 'X']])
        expect(winning_board).to be_win_game
      end

      it 'returns true' do
        winning_board = TicTacBoard.new([
          [' ', ' ', 'O'],
          [' ', 'O', ' '],
          ['O', ' ', ' ']
        ])
        allow(winning_board).to receive(:diagonals).with(winning_board.board).and_return([[' ', 'O', ' '], ['O', 'O', 'O']])
        allow(winning_board).to receive(:columns).with(winning_board.board).and_return([[' ', ' ', 'O'], [' ', 'O', ' '], [' ', ' ', 'O']])
        expect(winning_board).to be_win_game
      end
    end

    context 'when winner across a row' do
      it 'returns true' do
        winning_board = TicTacBoard.new([
          ['X', 'X', 'X'],
          [' ', ' ', ' '],
          [' ', ' ', ' ']
        ])
        expect(winning_board).to be_win_game
      end

      it 'returns true' do
        winning_board = TicTacBoard.new([
          [' ', ' ', ' '],
          ['X', 'X', 'X'],
          [' ', ' ', ' ']
        ])
        expect(winning_board).to be_win_game
      end

      it 'returns true' do
        winning_board = TicTacBoard.new([
          [' ', ' ', ' '],
          [' ', ' ', ' '],
          ['X', 'X', 'X']
        ])
        expect(winning_board).to be_win_game
      end
    end

    context 'when winner across a column' do
      it 'returns true' do
        winning_board = TicTacBoard.new([
          ['X', ' ', ' '],
          ['X', ' ', ' '],
          ['X', ' ', ' ']
        ])
        expect(winning_board).to be_win_game
      end

      it 'returns true' do
        winning_board = TicTacBoard.new([
          [' ', 'X', ' '],
          [' ', 'X', ' '],
          [' ', 'X', ' ']
        ])
        expect(winning_board).to be_win_game
      end

      it 'returns true' do
        winning_board = TicTacBoard.new([
          [' ', ' ', 'X'],
          [' ', ' ', 'X'],
          [' ', ' ', 'X']
        ])
        expect(winning_board).to be_win_game
      end
    end
  end

  describe '#draw_game?' do
    context 'when board is full' do
      it 'returns true' do
        draw_board = TicTacBoard.new([
          ['X', 'O', 'X'],
          ['X', 'X', 'O'],
          ['O', 'X', 'O']
        ])
        expect(draw_board).to be_draw_game
      end
    end

    context 'when board is not full' do
      it 'returns false' do
        incomplete_board = TicTacBoard.new([
          [' ', 'O', ' '],
          ['X', 'X', 'O'],
          ['O', ' ', ' ']
        ])
        expect(incomplete_board).not_to be_draw_game
      end
    end
  end

  describe '#empty_space?' do
    let(:game_board) { described_class.new([
      [' ', 'O', 'X'],
      ['X', ' ', 'O'],
      ['O', ' ', 'O']
      ]) }

    context 'when select space is empty' do
      it 'returns true' do
        expect(game_board.empty_space?(0, 0)).to eql(true)
      end
    end

    context 'when select space is not empty' do
      it 'returns false' do
        expect(game_board.empty_space?(0, 1)).to eql(false)
      end
    end
  end

  describe '#player_selection' do
    it 'changes board element at select location' do
      new_board = TicTacBoard.new
      new_board.player_selection(0, 0, 'X')
      expect(new_board.board[0][0]).to eql('X')
    end
  end
end
