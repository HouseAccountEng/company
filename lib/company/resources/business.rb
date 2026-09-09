module Company
  # Who the account belongs to: the one business behind a set of credentials.
  class Business < Resource
    # What every business reads, by the vocabulary's names.
    def self.attributes = %i[id name phone]

    # @return [String] business name.
    def name = attribute :name

    # @return [String, nil] ten digits the business is reached on, nil where none can be dialed.
    def phone = Phone.from attribute(:phone)
  end
end
