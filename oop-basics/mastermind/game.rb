# frozen_string_literal: true

require './game_text'

# Mastermind game logic and functionality to play game
class Game
  attr_accessor :computer, :human, :remaining_guesses

  include GameText

  def initialize
    @computer = ComputerPlayer.new
    @human = HumanPlayer.new
    @remaining_guesses = 12
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
    explain_rules('human_cb')

    loop do
      guess = human.construct_code
      @remaining_guesses -= 1

      if game_over?(guess, hidden_code)
        correct_guess?(guess, hidden_code) ? (puts win_message('human_cb')) : (puts lose_message('human_cb'))
        break
      else
        feedback = code_feedback(guess, hidden_code)
        feedback_message(feedback[0], feedback[1])
        remaining_turns_message(remaining_guesses)
      end
    end
  end

  def human_cm
    explain_rules('human_cm')
    hidden_code = human.construct_code

    loop do
      guess = computer.break_code
      @remaining_guesses -= 1
      puts "\nRubyBot: Is the code... #{guess}?"

      if game_over?(guess, hidden_code)
        correct_guess?(guess, hidden_code) ? (puts lose_message('human_cm')) : (puts win_message('human_cm'))
        break
      else
        feedback = code_feedback(guess, hidden_code)
        feedback_message(feedback[0], feedback[1])
        computer.update_possible_combos(feedback[0], feedback[1])
        remaining_turns_message(remaining_guesses)
      end
    end
  end

  # Check game conditions
  def game_over?(guess, code)
    correct_guess?(guess, code) || zero_rounds_left?
  end

  def zero_rounds_left?
    @remaining_guesses <= 0
  end

  def correct_guess?(guess, code)
    guess == code
  end

  def code_feedback(guess, code)
    correct_colors = 0
    correct_pegs = 0

    # Create duplicate array to modify without altering original
    temp = code.dup

    guess.each_with_index do |guess_peg, guess_idx|
      next unless temp.include?(guess_peg)

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
