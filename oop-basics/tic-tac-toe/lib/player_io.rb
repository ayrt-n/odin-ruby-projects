ACCEPTABLE_VALUES = %w[0 1 2]

def prompt_move(prompt)
  input = ''
  loop do
    print prompt
    input = gets.chomp

    break if ACCEPTABLE_VALUES.include?(input)

    puts 'Incorrect input: Value must be between 0-2'
  end
  input.to_i
end

