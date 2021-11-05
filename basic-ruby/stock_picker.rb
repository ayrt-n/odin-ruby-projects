def stock_picker(prices)
  # Hash to keep track of most profitable trading days
  profit = {
    index: [],
    prices: []
  }

  # Iterate through array and sub array which has dropped prior days
  # If the current iteration is more profitable than the one currently
  # saved in the hash, then replace the hash values
  prices.each_with_index do |curr_price, idx1|
    prices.drop(idx1).each_with_index do |future_price, idx2|
      # Check if price array empty, if not populate
      if profit[:prices].empty? 
        profit[:prices] = [curr_price, future_price]
        profit[:index] = [idx1, idx1 + idx2]
      # Check if current buy/sell combo has greater profit than that in price array
      elsif (future_price - curr_price) > profit[:prices][1] - profit[:prices][0]
        profit[:prices] = [curr_price, future_price]
        profit[:index] = [idx1, idx1 + idx2]
      end
    end
  end
  profit[:index]
end

stock_prices = [63,3,6,9,15,8,6,1,1]

print stock_picker(stock_prices)
puts ""