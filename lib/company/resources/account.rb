module Company
  # The business the credentials belong to.
  class Account < Resource
    # @return [String] what the business calls itself.
    def name = attribute :name

    # However the platform wrote the number, a caller dials the same ten digits.
    # @return [String, nil] the ten digits to dial, or nil where the platform holds none.
    # @raise [Error] where the platform holds one that is not a North American number.
    def phone = Phone.from attribute(:phone)
  end
end
