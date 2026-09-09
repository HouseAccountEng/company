module Company
  # One line of a document: how many of a thing, what it is called, and what it comes to.
  class Line < Resource
    # What every line reads, by the vocabulary's names.
    def self.attributes = %i[id name description quantity amount]

    # @return [String, nil] what the line is called.
    def name = attribute :name

    # @return [String, nil] what the line says beyond what it is called.
    def description = attribute :description

    # A whole quantity reads as an Integer -- `3 Faucets` rather than `3.0 Faucets` -- and a
    # fraction keeps its point, since rounding it would lie about what was billed.
    # @return [Integer, Float, nil] how many of it the document is for.
    def quantity = whole attribute(:quantity)

    # @return [BigDecimal, nil] what the line comes to, in dollars.
    def amount = decimal :amount

    # @return [String] how many of what: `3 Bathroom Faucet Installation`, or the name alone
    #   where the platform holds no quantity for the line.
    def to_s = [ quantity, name ].compact.join ' '

  private

    def whole(number) = number && ((number % 1).zero? ? number.to_i : number)
  end
end
