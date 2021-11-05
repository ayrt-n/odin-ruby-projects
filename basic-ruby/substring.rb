def substrings(string, substrings)
  string_downcase = string.downcase
  string_downcase = string_downcase.split(" ") # Convert to array to iterate over
  sub_downcase = substrings.map { |substring| substring.downcase }

  sub_downcase.reduce(Hash.new(0)) do |hash, substring|
    string_downcase.each do |word|
      while word.include?(substring)
        hash[substring] += 1 # If it includes the substring add one to hash
        word = word.sub(substring, "") # Remove occurence of substring and test again
      end
    end
    hash
  end
end


dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

puts substrings("below", dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
puts substrings("invinsible", dictionary)
