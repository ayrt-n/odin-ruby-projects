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

        puts "Invalid guess - Please select {#COLORS[0...-1].join(', ')}" +
          ", or #{COLORS[-1]}."
      end
    end
  end

  class Game
    attr_accessor :computer, :human

    def initialize
      @computer = ComputerPlayer.new()
      @human = HumanPlayer.new()
    end

    def play
      hidden_code = computer.random_code
      round_count = 1

      loop do
        guess = human.guess_code

        if guess == hidden_code
          #winner winner
          break
        elsif round_count > 10 # Set maximum attempts to 10
          #loser loser
          break
        else
          # provide constructive criticism
        end
      end
    end
  end
end


Mastermind::Game.new.play
