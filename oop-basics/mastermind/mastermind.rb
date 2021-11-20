module Mastermind
  COLORS = %w[red orange yellow green blue purple].freeze
  LENGTH = 4

  class ComputerPlayer
    def initialize
      # Index to iterate and keep track through the array of potential colors
      @bg_index = 0
      # Hash to keep track of guesses/feedback when breaking code
      @feedback = create_memory_hash
      # Create array to keep track of correct guesses
      @best_guess = []
      # Variable to keep track of how many correct pegs found
      @correct_pegs = 0
    end

    # Guesses code, incorporating feedback if any
    def break_code
      if @correct_pegs == 4
        @best_guess.shuffle
      else
        iterate_guess
      end
    end

    def update_feedback(correct_guesses)
      if correct_guesses.zero?
        @bg_index += 1 # Update index for next guess
        return # Fast quit if no feedback
      else
        new_info = correct_guesses - @correct_pegs
        new_info.times { @best_guess << COLORS[@bg_index] }
        @correct_pegs += new_info
        @bg_index += 1
        puts "found #{@correct_pegs} correct pegs"
        puts "the new best guess is #{@best_guess}"
      end
    end

    # Constructs array of random colors, return array with code used when code maker
    def random_code
      code = []
      LENGTH.times { code << COLORS[rand(COLORS.size)] }
      code
    end

    private

    def iterate_guess
      if @correct_pegs.zero?
        Array.new(LENGTH, COLORS[@bg_index])
      else
        guess = [].concat(@best_guess)
        pegs_missing = LENGTH - @correct_pegs
        pegs_missing.times { guess << COLORS[@bg_index]}
        guess
      end
    end

    def create_memory_hash
      Hash[COLORS.map { |color| [color, 0] }]
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

      loop do
        game_type = gets.chomp

        case game_type
        when '1'
          human_cb
          break
        when '2'
          human_cm
          break
        end

        wrong_type_message
      end
    end

    private

    def human_cb
      hidden_code = computer.random_code
      puts hidden_code

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
        guess = computer.break_code
        remaining_guesses -= 1
        puts "the guess is : #{guess}"

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
          feedback = code_feedback(guess, hidden_code).sum
          feedback_message(guess, hidden_code)
          puts "feedback #: #{feedback}"
          computer.update_feedback(feedback)
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

    def wrong_type_message
      puts ''
      puts 'Invalid selection - Please enter 1 or 2'
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
      puts "You successfully guessed #{feedback[0]} peg(s)."
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

      # Create duplicate array to modify without altering original
      temp = code.dup

      guess.each_with_index do |guess_peg, guess_idx|
        if temp.include?(guess_peg)
          match_idx = temp.index(guess_peg)
          if match_idx == guess_idx
            correct_pegs += 1
            temp[match_idx] = ''
          elsif guess[match_idx] == temp[match_idx]
            correct_pegs += 1
            temp[match_idx] = ''
          else
            correct_colors += 1
            temp[match_idx] = ''
          end
        end
      end

      [correct_pegs, correct_colors]
    end
  end
end

Mastermind::Game.new.play
