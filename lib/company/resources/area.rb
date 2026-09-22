module Company
  # A named group of ZIP codes the business serves.
  class Area < Resource
    # What every area reads, by the vocabulary's names.
    def self.attributes = %i[id name zips]

    # @return [String, nil] what the business calls it.
    def name = attribute :name

    # @return [Array<String>] ZIP codes it covers.
    def zips = attribute :zips
  end
end
