module Company
  # The business the credentials belong to.
  class Account < Resource
    # What every account reads, by the vocabulary's names.
    def self.attributes = %i[id name phone]

    # @return [String] business name.
    def name = attribute :name

    # @return [String, nil] 10-digits phone number.
    # @raise [Error] raised if phone is not a valid 10-digits North American number.
    def phone = Phone.from attribute(:phone)
  end
end
