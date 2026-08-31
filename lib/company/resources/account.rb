module Company
  # The business the credentials belong to.
  class Account < Resource
    # @return [String, nil] what the business calls itself.
    def name = attribute :name

    # @return [String, nil] the number the business is reached on, as the platform holds it.
    def phone = attribute :phone

    # @return [String, nil] the address the business is written to.
    def email = attribute :email

    # @return [String, nil] where the business is on the web.
    def website = attribute :website

    # @return [String, nil] the zone the business books its days in.
    def zone = attribute :zone
  end
end
