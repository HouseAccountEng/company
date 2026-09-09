module Company
  # Who the account belongs to: the one business behind a set of credentials.
  class Business < Resource
    # What every business reads, by the vocabulary's names.
    def self.attributes = %i[id name phone]

    # @return [String] business name.
    def name = attribute :name

    # @return [String, nil] ten digits the business is reached on, nil where none can be dialed.
    def phone = Phone.from attribute(:phone)

    # Itself first, then every business under it at any depth, in the order the platform lists
    # them: a business on its own is its own one subsidiary, and a franchise reads flat. A gem
    # whose platform nests businesses answers the ones directly under this one from the private
    # `below`; the rest inherit none.
    # @return [Array<Business>] businesses an account may act as, this one included.
    def subsidiaries = [ self, *below.flat_map(&:subsidiaries) ]

  private

    def below = []
  end
end
