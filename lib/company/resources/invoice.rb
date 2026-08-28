module Company
  # A bill the business issued for finished work.
  class Invoice < Resource
    include Itemized, Timestamped

    # An invoice's half of the ledger is the one it was issued on.
    def self.window = :issued_at

    # @return [String, nil] the ID of the job the invoice bills.
    def job_id = @attributes[:job_id]

    # @return [String, nil] the ID of the customer the invoice went to.
    def customer_id = @attributes[:customer_id]

    # @return [String, nil] the number the business prints on it.
    def number = @attributes[:number]

    # @return [String, nil] where the invoice stands: drafted, sent, paid, or overdue.
    def status = @attributes[:status]

    # @return [BigDecimal, Float, nil] what is still owed on it, in dollars.
    def balance = @attributes[:balance]

    # @return [Time, nil] when the invoice went to the customer.
    def issued_at = @attributes[:issued_at]

    # @return [Time, nil] when the invoice falls due.
    def due_at = @attributes[:due_at]

    # @return [Job, nil] the work the invoice bills, where it came back with the invoice.
    def job = record Job, :job

    # @return [Relation] the money taken against the invoice.
    def payments = @company.payments.where invoice_id: id
  end
end
