module Company
  # A price the business sent to answer a lead.
  class Quote < Resource
    # What every quote reads, by the vocabulary's names.
    def self.attributes = %i[id amount]

    # @return [Lead, nil] lead the quote answers, where it came back beside the quote.
    def lead = record Lead, :lead

    # @return [BigDecimal, nil] what the quote comes to, in dollars.
    def amount = decimal :amount
  end
end
