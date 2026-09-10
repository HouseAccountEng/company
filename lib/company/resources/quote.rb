module Company
  # A price the business sent a customer, which a job names where it was won with one.
  class Quote < Resource
    # What every quote reads, by the vocabulary's names.
    def self.attributes = %i[id amount]

    # @return [BigDecimal, nil] what the quote comes to, in dollars.
    def amount = decimal :amount
  end
end
