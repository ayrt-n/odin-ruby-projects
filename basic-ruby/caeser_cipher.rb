def caeser_cipher(string, shift = 0)
  string_array = string.split("")
  #.ord to convert char to ascii value, .chr to convert ascii back to char
  string_array.map! { |chr| shift_ascii(chr.ord, shift).chr}
  string_array.join
end


# shift_ascii will increment/decrement ascii value by shift amount for use
# in caeser_cipher above (only shifting for alpha values)
def shift_ascii(ascii_val, shift)

  # If large shift replace with remainder of division by 26
  shift = shift.remainder(26) if (shift > 26 || shift < -26)

  # Case for lowercase letters
  if ascii_val.between?(97, 122)
    new_ascii = ascii_val + shift

    # New ascii <97 or >122 implies it is out of range (a-z)
    new_ascii = (new_ascii - 96) + 122 if new_ascii < 97  
    new_ascii = (new_ascii - 123) + 97 if new_ascii > 122 
    
    new_ascii

  # Case for uppercase letters
  elsif ascii_val.between?(65, 90)
    new_ascii = ascii_val + shift

    # New ascii <65 or >90 implies it is out of range (A-Z)
    new_ascii = (new_ascii - 64) + 90 if new_ascii < 65
    new_ascii = (new_ascii - 91) + 65 if new_ascii > 90

    new_ascii

  # Default case (if not alpha value, don't shift ascii)
  else
    ascii_val
  end
end


puts "Enter string to encode: "
string = gets.chomp

puts "Enter shift factor: "
shift = gets.chomp.to_i

puts caeser_cipher(string, shift)