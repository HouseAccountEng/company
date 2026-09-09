module Company
  # A bill the business issued for finished work.
  class Invoice < Resource
    # What every invoice reads, by the vocabulary's names.
    def self.attributes = %i[id job_id amount completed_at issued_at]

    # @return [String, nil] ID of the job the invoice bills.
    def job_id = attribute :job_id

    # @return [BigDecimal, nil] what the invoice comes to, in dollars.
    def amount = decimal :amount

    # @return [Time, nil] moment the billed work was finished, or the bill issued where undated.
    def fulfilled_at = completed_at || issued_at

  private

    def completed_at = time :completed_at

    def issued_at = time :issued_at
  end
end
