# frozen_string_literal: true

# Provides game text (instructions/errors) to user
module GameText
  COLORS = %w[red orange yellow green blue purple].freeze

  # Following methods all provide messages/instructions to the player
  def welcome_message
    puts "\nWelcome to Ruby Mastermind! Would you like to play as the:\n"
    puts "(1) Code breaker or the (2) Code maker\n"
  end

  def wrong_type_message
    puts "\nInvalid selection - Please enter 1 or 2\n"
  end

  # Explain rules
  def explain_rules(game_type)
    if game_type == 'human_cb'
      puts "\nThe computer has constructed a four color code composed" \
      " of the following potential colors:\n"
      print "#{COLORS}\n"
      puts "You have 12 guesses to find the correct answer. Good luck!\n"
    else
      puts "\nBuild a secret code using any of the following potential colors:\n"
      print "#{COLORS}\n"
      puts "Once finished, the computer will attempt to crack the code.\n"
    end
  end

  def remaining_turns_message(remaining_guesses)
    puts "Guesses remaining: #{remaining_guesses}\n"
  end

  def feedback_message(correct_pegs, correct_colors)
    puts "\nSuccessfully guessed #{correct_pegs} peg(s)."
    puts "Of the remaining pegs, the guess includes the right color #{correct_colors} time(s).\n"
  end

  # Message if #winner? true
  def win_message(game_type)
    {
      'human_cm' => "\nYou win! The computer was unable to crack the code.\n",
      'human_cb' => "\nYou win! You cracked the code!\n"
    }[game_type]
  end

  def lose_message(game_type)
    {
      'human_cm' => "\nGame over! The computer cracked the code!\n",
      'human_cb' => "\nGame over! You were unable to break the code.\n"
    }[game_type]
  end
end
