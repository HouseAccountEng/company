module Company
  # Somebody who asked the business for work and is not a customer yet.
  class Lead < Resource
    # What every lead reads, by the vocabulary's names.
    def self.attributes = %i[id customer_id]

    # @return [String, nil] ID of the customer the lead was filed for.
    def customer_id = attribute :customer_id
  end
end
