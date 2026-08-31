module Company
  # What every record shares: the node the platform answered it as, and the company it was
  # read from. Built by the company, never by a caller.
  class Resource
    # The node keys the platform spells otherwise than the vocabulary, by the reader they
    # answer: `{ phone: :phone_number }` reads {Account#phone} off `phone_number`. A gem
    # declares its own; a reader left out reads the key of its own name.
    # @return [Hash] reader-to-key exceptions, empty where every name is its key.
    def self.keys = {}

    # @param company [Company] business the record was read from.
    # @param node [Hash] record as the platform answered it, keyed by symbols.
    def initialize(company:, node: {})
      strings = node.keys.grep_v Symbol
      raise ArgumentError, "node keys are not symbols: #{strings.join ', '}" if strings.any?

      @node = node
      @company = company
    end

    # @return [String] ID the company files the record under.
    def id = attribute :id

  private

    def node = @node

    def attribute(name) = node[self.class.keys.fetch(name, name)]
  end
end
