# frozen_string_literal: true

require './mastermind_constants'
require './array_extensions'
require 'byebug'

# Functionality for AI opponent (making + breaking codes)
class ComputerPlayer
  include MastermindConstants
  include ArrayExtensions

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
        not_x_index_matches?(combo, @prev_guess, correct_pegs) ||
          combo == @prev_guess
      end
    else
      # Look for all combinations of correct colors that might be included
      possible_values_included = @prev_guess.combination(correct_colors).to_a

      @possible_combinations.reject! do |combo|
        not_x_index_matches?(combo, @prev_guess, correct_pegs) ||
          array_not_include_any_set_of_arrays?(combo, possible_values_included) ||
          combo == @prev_guess
      end
    end
  end

  # Constructs array of random colors, return array with code used when code maker
  def random_code
    code = []
    LENGTH.times { code << COLORS[rand(COLORS.size)] }
    code
  end
end
