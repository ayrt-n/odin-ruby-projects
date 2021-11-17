module Mastermind
  COLORS = %w[red orange yellow green blue purple].freeze
  LENGTH = 4

  class Code
    attr_reader :code

    def initialize(code)
      @code = code
    end
  end

  class ComputerPlayer
    def random_code
      code = []
      LENGTH.times { code << COLORS[rand(LENGTH)] }
      code
    end
  end

  class HumanPlayer
    def guess_code
      guess_array = []
      count = 1
      loop do
        guess_array << human_guess
        count += 1
        break if count > LENGTH
      end
      guess_array
    end

    private

    def human_guess
      loop do
        guess = gets.chomp

        return guess if COLORS.include?(guess)

        puts "Invalid guess - Please select #{COLORS[0...-1].join(', ')}" +
          ", or #{COLORS[-1]}."
      end
    end
  end

  class Game
    attr_accessor :computer, :human

    def initialize
      @computer = ComputerPlayer.new
      @human = HumanPlayer.new
    end

    def play
      hidden_code = computer.random_code
      puts hidden_code
      remaining_guesses = 10

      loop do
        guess = human.guess_code
        remaining_guesses -= 1

        if winner?(guess, hidden_code)
          puts 'You win! You cracked the code!'
          break
        elsif remaining_guesses <= 0  # Set maximum attempts to 10
          puts 'Game over! You were unable to break the code.'
          break
        else
          feedback_message(guess, hidden_code)
          remaining_message(remaining_guesses)
        end
      end
    end

    private

    def winner?(guess, code)
      guess == code
    end

    def remaining_message(remaining_guesses)
      if remaining_guesses == 1
        puts "You have #{remaining_guesses} guess remaining."
      else
        puts "You have #{remaining_guesses} guesses remaining."
      end
    end

    def feedback_message(guess, code)
      feedback = code_feedback(guess, code)
      puts "You successfully guessed #{feedback[0]} pegs."
      puts "Of the remaining pegs, your guess includes the right color #{feedback[1]} time(s)"
    end

    def code_feedback(guess, code)
      correct_colors = 0
      correct_pegs = 0

      # Count pegs with correct position AND color
      incorrect_guess = []
      remaining_code = []

      guess.each_with_index do |peg, idx|
        if peg == code[idx]
          correct_pegs += 1
        else
          incorrect_guess << peg
          remaining_code << code[idx]
        end
      end

      # Check remaining pegs to see if correct colors remain
      incorrect_guess.each do |peg|
        correct_colors += 1 if remaining_code.include?(peg)
      end

      [correct_pegs, correct_colors]
    end
  end
end


Mastermind::Game.new.play
