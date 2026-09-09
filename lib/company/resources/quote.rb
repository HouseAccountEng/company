module Company
  # A price the business sent to answer a lead.
  class Quote < Resource
    # What every quote reads, by the vocabulary's names.
    def self.attributes = %i[id lead_id amount]

    # @return [String, nil] ID of the lead the quote answers.
    def lead_id = attribute :lead_id

    # @return [BigDecimal, nil] what the quote comes to, in dollars.
    def amount = decimal :amount
  end
end
