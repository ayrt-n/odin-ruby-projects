# frozen_string_literal: true

require './game_text'

# Mastermind game logic and functionality to play game
class Game
  attr_accessor :computer, :human

  include GameText

  def initialize
    @computer = ComputerPlayer.new
    @human = HumanPlayer.new
  end

  def play
    welcome_message
    game_type = gets.chomp

    loop do
      break if %w[1 2].include?(game_type)

      wrong_type_message
      game_type = gets.chomp
    end

    game_type == '1' ? human_cb : human_cm
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
        feedback = code_feedback(guess, hidden_code)
        feedback_message(feedback[0], feedback[1])
        remaining_turns_message(remaining_guesses)
      end
    end
  end

  def human_cm
    explain_rules_cm
    hidden_code = human.construct_code

    # Maximum number of guesses set to 12
    remaining_guesses = 12

    puts ''
    loop do
      guess = computer.break_code
      remaining_guesses -= 1
      puts "RubyBot: Is the code... #{guess}?"

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
        remaining_turns_message(remaining_guesses)
      end
    end
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
      next if temp.exclude?(guess_peg)

      match_idx = temp.index(guess_peg)
      if guess_peg == temp[guess_idx]
        correct_pegs += 1
      elsif guess[match_idx] == temp[match_idx]
        correct_pegs += 1
      else
        correct_colors += 1
      end
      temp[match_idx] = ''
    end

    [correct_pegs, correct_colors]
  end
end
