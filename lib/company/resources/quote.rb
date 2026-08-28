module Company
  # A price the business sent to a customer.
  class Quote < Resource
    include Itemized, Named, Timestamped

    # @return [String, nil] the ID of the customer the quote went to.
    def customer_id = @attributes[:customer_id]

    # @return [String, nil] the ID of the lead the quote answers.
    def lead_id = @attributes[:lead_id]

    # @return [String, nil] where the quote stands: drafted, sent, approved, or turned down.
    def status = @attributes[:status]

    # @return [Time, nil] when the quote went to the customer.
    def sent_at = @attributes[:sent_at]

    # @return [Customer, nil] who the quote went to, where they came back with it.
    def customer = record Customer, :customer

    # @return [Relation] the work the quote was won as.
    def jobs = @company.jobs.where quote_id: id
  end
end
