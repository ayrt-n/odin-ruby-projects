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
    # Method for player to construct a code of length LENGTH
    # Returns array with code. Can be used for breaking or making code.
    def construct_code
      code_array = []
      count = 1
      loop do
        code_array << prompt_code_input(count)
        count += 1
        break if count > LENGTH
      end
      code_array
    end

    private

    def prompt_code_input(count)
      loop do
        print "#{count}. "
        input = gets.chomp

        return input if COLORS.include?(input)

        invalid_input
      end
    end

    def invalid_input
      puts ''
      puts "Invalid input - Please select #{COLORS[0...-1].join(', ')}" +
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
        guess = human.construct_code
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
      explain_rules_cm
      hidden_code = human.construct_code

      # Maximum number of guesses set to 12
      remaining_guesses = 12

      loop do
        guess = computer.guess_code
        remaining_guesses -= 1

        if winner?(guess, hidden_code)
          puts ''
          puts 'Game over! The computer cracked the code!'
          puts ''
          break
        elsif remaining_guesses <= 0
          puts ''
          puts 'You win! The computer was unable to crack the code.'
          puts ''
          break
        else
          feedback_message(guess, hidden_code)
          remaining_turns_message(remaining_guesses)
        end

      end
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

    def explain_rules_cm # Explain rules to human code maker
      puts ''
      puts 'Build a secret code using any of the following potential colors:'
      puts ''
      print "#{COLORS}\n"
      puts ''
      puts 'Once finished, the computer will attempt to crack the code.'
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
