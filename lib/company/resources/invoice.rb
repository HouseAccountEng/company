module Company
  # A bill the business issued for finished work.
  class Invoice < Resource
    include Itemized, Timestamped

    # An invoice's half of the ledger is the one it was issued on.
    def self.window = :issued_at

    # @return [String, nil] the ID of the job the invoice bills.
    def job_id = attribute :job_id

    # @return [String, nil] the ID of the customer the invoice went to.
    def customer_id = attribute :customer_id

    # @return [String, nil] the number the business prints on it.
    def number = attribute :number

    # @return [String, nil] where the invoice stands: drafted, sent, paid, or overdue.
    def status = attribute :status

    # @return [BigDecimal, Float, nil] what is still owed on it, in dollars.
    def balance = attribute :balance

    # @return [Time, nil] when the invoice went to the customer.
    def issued_at = time :issued_at

    # @return [Time, nil] when the invoice falls due.
    def due_at = time :due_at

    # @return [Job, nil] the work the invoice bills, where it came back with the invoice.
    def job = record Job, :job

    # @return [Relation] the money taken against the invoice.
    def payments = @company.payments.where invoice_id: id
  end
end
