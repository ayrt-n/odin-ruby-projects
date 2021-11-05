def bubble_sort(array)
  loop do
    sorted = true # Flag variable to check whether array is sorted
    (0...array.length - 1).each do |idx|
      if array[idx] > array[idx + 1]
        array[idx], array[idx + 1] = array[idx + 1], array[idx]
        sorted = false # If a change is made, was not sorted, will have to run loop again
      end
    end
    break if sorted == true
  end
  array
end

array = [4,3,78,2,0,2]

print bubble_sort(array)
puts ""

