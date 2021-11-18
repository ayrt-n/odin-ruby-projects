module Mastermind
  COLORS = %w[red orange yellow green blue purple].freeze
  LENGTH = 4

  class ComputerPlayer
    def random_code
      code = []
      LENGTH.times { code << COLORS[rand(COLORS.size)] }
      code
    end
  end

  class HumanPlayer
    def guess_code
      guess_array = []
      count = 1
      loop do
        guess_array << prompt_guess(count)
        count += 1
        break if count > LENGTH
      end
      guess_array
    end

    private

    def prompt_guess(count)
      loop do
        print "#{count}. "
        guess = gets.chomp

        return guess if COLORS.include?(guess)

        invalid_guess
      end
    end

    def invalid_guess
      puts ''
      puts "Invalid guess - Please select #{COLORS[0...-1].join(', ')}" +
      ", or #{COLORS[-1]}."
      puts ''
    end
  end

  class Game
    attr_accessor :computer, :human

    def initialize
      @computer = ComputerPlayer.new
      @human = HumanPlayer.new
    end

    def play
      welcome_message
      game_type = gets.chomp

      if game_type == '1'
        human_cb
      else
        human_cm
      end
    end

    private

    def human_cb
      hidden_code = computer.random_code

      # Maximum number of guesses set to 12
      remaining_guesses = 12

      explain_rules_cb

      loop do
        guess = human.guess_code
        remaining_guesses -= 1

        if winner?(guess, hidden_code)
          puts ''
          puts 'You win! You cracked the code!'
          puts ''
          break
        elsif remaining_guesses <= 0
          puts ''
          puts 'Game over! You were unable to break the code.'
          print "The correct code was #{hidden_code}"
          puts ''
          break
        else
          feedback_message(guess, hidden_code)
          remaining_turns_message(remaining_guesses)
        end
      end
    end

    def human_cm
      puts 'TO DO'
    end

    # Following methods all provide messages/instructions to the player
    def welcome_message
      puts ''
      puts 'Welcome to Ruby Mastermind! Would you like to play as the:'
      puts ''
      puts '(1) Code breaker or the (2) Code maker'
      puts ''
    end

    def explain_rules_cb # Explain rules to human code breaker
      puts ''
      puts 'The computer has constructed a four color code composed' +
      ' of the following potential colors:'
      puts ''
      print "#{COLORS}\n"
      puts ''
      puts 'You have 12 guesses to find the correct answer. Good luck!'
      puts ''
    end

    def remaining_turns_message(remaining_guesses)
      if remaining_guesses == 1
        puts "You have #{remaining_guesses} guess remaining."
      else
        puts "You have #{remaining_guesses} guesses remaining."
      end
      puts ''
    end

    def feedback_message(guess, code)
      feedback = code_feedback(guess, code)
      puts ''
      puts "You successfully guessed #{feedback[0]} pegs."
      puts "Of the remaining pegs, your guess includes the right color #{feedback[1]} time(s)"
      puts ''
    end

    # Following methods used to evaluate the guess relative to code
    def winner?(guess, code)
      guess == code
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
