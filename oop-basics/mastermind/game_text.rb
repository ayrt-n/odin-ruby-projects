# frozen_string_literal: true

# Provides game text (instructions/errors) to user
module GameText
  COLORS = %w[red orange yellow green blue purple].freeze

  # Following methods all provide messages/instructions to the player
  def welcome_message
    puts "\nWelcome to Ruby Mastermind! Would you like to play as the:"
    puts ''
    puts '(1) Code breaker or the (2) Code maker'
    puts ''
  end

  def wrong_type_message
    puts "\nInvalid selection - Please enter 1 or 2"
    puts ''
  end

  # Explain rules to human code breaker
  def explain_rules_cb
    puts "\nThe computer has constructed a four color code composed" \
    ' of the following potential colors:'
    puts ''
    print "#{COLORS}\n"
    puts ''
    puts 'You have 12 guesses to find the correct answer. Good luck!'
    puts ''
  end

  # Explain rules to human code maker
  def explain_rules_cm
    puts "\nBuild a secret code using any of the following potential colors:"
    puts ''
    print "#{COLORS}\n"
    puts ''
    puts 'Once finished, the computer will attempt to crack the code.'
    puts ''
  end

  def remaining_turns_message(remaining_guesses)
    puts "Guesses remaining: #{remaining_guesses}"
    puts ''
  end

  def feedback_message(correct_pegs, correct_colors)
    puts "\nSuccessfully guessed #{correct_pegs} peg(s)."
    puts "Of the remaining pegs, the guess includes the right color #{correct_colors} time(s)."
    puts ''
  end
end
