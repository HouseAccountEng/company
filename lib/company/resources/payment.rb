module Company
  # Money the business took against an invoice.
  class Payment < Resource
    # A payment's half of the ledger is the one it was taken on.
    def self.window = :paid_at

    # @return [String, nil] the ID of the invoice the payment goes against.
    def invoice_id = attribute :invoice_id

    # @return [String, nil] the ID of the customer who paid.
    def customer_id = attribute :customer_id

    # @return [BigDecimal, Float, nil] how much was taken, in dollars.
    def amount = attribute :amount

    # @return [String, nil] how it was paid: card, check, cash.
    def method = attribute :method

    # @return [Time, nil] when it was taken.
    def paid_at = time :paid_at

    # @return [Invoice, nil] what the payment goes against, where it came back with the payment.
    def invoice = record Invoice, :invoice
  end
end
