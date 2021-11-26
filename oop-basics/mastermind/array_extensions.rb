# frozen_string_literal: true

# Additional array methods useful to the computer for breaking the code
module ArrayExtensions
  def array_include_any?(array, subarray)
    # Checks if the array includes any values from the subarray and returns bool
    # If the array includes of the subarray, size will be smaller than original
    (array - subarray).size < array.size
  end

  def array_include_all?(array, subarray)
    # Checks if array includes all values from subarray and returns bool
    # If array includes all, difference between arrays should equal difference
    # in size of arrays
    intersection = array_intersection_w_dups(array, subarray)
    (subarray - intersection).empty?
  end

  def array_intersection_w_dups(arr1, arr2)
    (arr1 & arr2).flat_map { |n| [n] * [arr1.count(n), arr2.count(n)].min }
  end

  def array_not_include_all?(array, subarray)
    # Checks if array does not include all values from subarray and returns bool
    !array_include_all?(array, subarray)
  end

  def array_not_include_any_set_of_arrays?(array, set_of_arrays)
    # Checks if array does not include all values from subarray
    set_of_arrays.each do |subarray|
      return false if array_include_all?(array, subarray)
    end
    true
  end

  def any_index_matches?(arr1, arr2)
    # Check if arrays have any matching values in same index and returns bool
    arr1.each_with_index do |value, idx|
      return true if value == arr2[idx]
    end
    false
  end

  def x_index_matches?(arr1, arr2, x_matches)
    # Check if two arrays have x number of matching values in the same index
    # Returns bool
    number_of_matches = 0
    arr1.each_with_index do |v1, idx1|
      number_of_matches += 1 if v1 == arr2[idx1]
    end
    number_of_matches == x_matches
  end

  def not_x_index_matches?(arr1, arr2, x_matches)
    # Check if two arrays do not have x number of matching values in the same index
    # Returns bool
    !x_index_matches?(arr1, arr2, x_matches)
  end
end
