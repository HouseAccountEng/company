module Company
  # The business the credentials belong to.
  class Account < Resource
    # @return [String, nil] what the business calls itself.
    def name = @attributes[:name]

    # @return [String, nil] the number the business is reached on, as ten digits.
    def phone = @attributes[:phone]

    # @return [String, nil] the address the business is written to.
    def email = @attributes[:email]

    # @return [String, nil] where the business is on the web.
    def website = @attributes[:website]

    # @return [String, nil] the zone the business books its days in.
    def time_zone = @attributes[:time_zone]

    # @return [Location, nil] where the business is run from.
    def location = record Location, :location
  end
end
