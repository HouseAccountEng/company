module Company
  # Where work happens: one address on a customer's file.
  class Location < Resource
    # @return [String, nil] the ID of the customer whose address it is.
    def customer_id = attribute :customer_id

    # @return [String, nil] the street, number included.
    def street = attribute :street

    # @return [String, nil] the town.
    def city = attribute :city

    # @return [String, nil] the state, as two letters.
    def state = attribute :state

    # @return [String, nil] the ZIP code.
    def zip = attribute :zip

    # @return [Float, nil] how far north.
    def latitude = attribute :latitude

    # @return [Float, nil] how far east.
    def longitude = attribute :longitude

    # @return [Customer, nil] whose address it is, where it came back with the location.
    def customer = record Customer, :customer

    # @return [String] the address on one line, from whatever parts of it the company holds.
    def to_s = [ street, city, [ state, zip ].compact_blank.join(' ') ].compact_blank.join ', '
  end
end
