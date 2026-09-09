module Company
  # Where work happens: one address the business drives to.
  class Location < Resource
    # What every location reads, by the vocabulary's names.
    def self.attributes = %i[id street city zip latitude longitude]

    # @return [String, nil] street, number included.
    def street = attribute :street

    # @return [String, nil] town.
    def city = attribute :city

    # @return [String, nil] ZIP code.
    def zip = attribute :zip

    # @return [Numeric, nil] how far north the place is.
    def latitude = attribute :latitude

    # @return [Numeric, nil] how far east the place is.
    def longitude = attribute :longitude

    # @return [Customer, nil] whose place it is, where they came back beside the location.
    def customer = record Customer, :customer
  end
end
