module Mastermind
  COLORS = %w[red orange yellow green blue purple].freeze
  LENGTH = 4

  class ComputerPlayer
    def initialize
      # Array of arrays to keep track of possible combinations
      @possible_combinations = COLORS.repeated_permutation(LENGTH).to_a
      # Variable to keep track of previous guess
      @prev_guess = []
    end

    # Computer attempts to break code, starting with constant initial guess
    # If the first guess has been made, guesses using possible combinations
    def break_code
      @prev_guess = if @prev_guess.empty?
                      %w[red red orange orange]
                    else
                      @prev_guess = @possible_combinations[0]
                    end
    end

    # Using output from Game#code_feedback, update the possible combos based on
    # the number of correct pegs and correct colors (wrong pegs)
    def update_possible_combos(correct_pegs, correct_colors)
      if correct_pegs.zero? && correct_colors.zero?
        @possible_combinations.reject! do |combo|
          array_include_any?(combo, @prev_guess)
        end
      elsif correct_pegs.zero?
        # Look for all combinations of correct colors that might be included
        possible_values_included = @prev_guess.combination(correct_colors).to_a

        @possible_combinations.reject! do |combo|
          any_index_matches?(combo, @prev_guess) ||
          array_not_include_any_set_of_arrays?(combo, possible_values_included)
        end
      elsif correct_colors.zero?
        @possible_combinations.reject! do |combo|
          not_x_index_matches?(combo, @prev_guess, correct_pegs)
        end
      else
        # Look for all combinations of correct colors that might be included
        possible_values_included = @prev_guess.combination(correct_colors).to_a

        @possible_combinations.reject! do |combo|
          not_x_index_matches?(combo, @prev_guess, correct_pegs) ||
          array_not_include_any_set_of_arrays?(combo, possible_values_included)
        end
      end
    end

    # Constructs array of random colors, return array with code used when code maker
    def random_code
      code = []
      LENGTH.times { code << COLORS[rand(COLORS.size)] }
      code
    end

    private

    def array_include_any?(array, subarray)
      # Checks if the array includes any values from the subarray and returns bool
      # If the array includes of the subarray, size will be smaller than original
      (array - subarray).size < array.size
    end

    def array_include_all?(array, subarray)
      # Checks if array includes all values from subarray and returns bool
      # If array includes all, difference between arrays should equal difference
      # in size of arrays
      remaining_elements = (array - subarray).size
      remaining_elements == (array.size - subarray.size)
    end

    def array_not_include_all?(array, subarray)
      # Checks if array does not include all values from subarray and returns bool
      !array_include_all?(array, subarray)
    end

    def array_not_include_any_set_of_arrays?(array, set_of_arrays)
      # Checks if array does not include all values from subarray
      set_of_arrays.each do |subarray|
        return false if array_include_all?(array, subarray)
      end
      true
    end

    def any_index_matches?(arr1, arr2)
      # Check if arrays have any matching values in same index and returns bool
      arr1.each_with_index do |value, idx|
        return true if value == arr2[idx]
      end
      false
    end

    def x_index_matches?(arr1, arr2, x_matches)
      # Check if two arrays have x number of matching values in the same index
      # Returns bool
      number_of_matches = 0
      arr1.each_with_index do |v1, idx1|
        number_of_matches += 1 if v1 == arr2[idx1]
      end
      number_of_matches == x_matches
    end

    def not_x_index_matches?(arr1, arr2, x_matches)
      # Check if two arrays do not have x number of matching values in the same index
      # Returns bool
      !x_index_matches?(arr1, arr2, x_matches)
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
          feedback = code_feedback(guess, hidden_code)
          feedback_message(guess, hidden_code)
          computer.update_possible_combos(feedback[0], feedback[1])
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
