module Company
  # One line of a document: how many of a thing, what it is called, and what it costs.
  class Line < Resource
    # @return [String, nil] what the line is called.
    def name = @attributes[:name]

    # @return [String, nil] what the line is, at more length than its name.
    def description = @attributes[:description]

    # @return [Integer, Float, nil] how many of it the document is for.
    def quantity = whole @attributes[:quantity]

    # @return [BigDecimal, Float, nil] what one of it costs, in dollars.
    def unit_price = @attributes[:unit_price]

    # @return [BigDecimal, Float, nil] what the line comes to, in dollars.
    def total = @attributes[:total]

    # @return [String] how many of what: `3 Bathroom Faucet Installation`, and the name alone
    #   where the company holds no quantity for the line.
    def to_s = [ quantity, name ].compact.join ' '

  private

    # A platform answers every quantity as a Float, and a whole one reads as an Integer:
    # `3 Faucets` rather than `3.0 Faucets`. A fraction keeps its point, since rounding it would
    # lie about what was billed.
    def whole(number) = number && ((number % 1).zero? ? number.to_i : number)
  end
end
