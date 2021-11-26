# frozen_string_literal: true

require './mastermind_constants'

# Functionality for human player (making + breaking codes)
class HumanPlayer
  include MastermindConstants

  # Prompts player to construct a code of length=LENGTH
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
    puts "Invalid input - Please select #{COLORS[0...-1].join(', ')}" \
    ", or #{COLORS[-1]}."
    puts ''
  end
end
