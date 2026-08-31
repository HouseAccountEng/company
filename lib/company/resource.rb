module Company
  # What every record shares: the node the platform answered it as, and the company it was
  # read from. Built by the company, never by a caller.
  class Resource
    # The node keys the platform spells otherwise than the vocabulary, by the reader they
    # answer: `{ phone: :phone_number }` reads {Account#phone} off `phone_number`. A gem
    # declares its own; a reader left out reads the key of its own name.
    # @return [Hash] reader-to-key exceptions, empty where every name is its key.
    def self.keys = {}

    # The keys a platform is expected to answer a node with: each attribute the kind reads,
    # through {.keys}, so a gem asks its platform for exactly these and writes none by hand.
    # @return [Array<Symbol>] node keys, in the order the attributes are read.
    def self.node_keys = attributes.map { |name| keys.fetch name, name }

    # @param company [Company] business the record was read from.
    # @param node [Hash] record as the platform answered it.
    def initialize(company:, node: {})
      @node = node.with_indifferent_access
      @company = company
    end

    # @return [String] ID the company files the record under.
    def id = attribute :id

  private

    def node = @node

    def attribute(name) = node[self.class.keys.fetch(name, name)]

    def time(name)
      value = attribute name
      value.is_a?(String) ? (Time.iso8601 value if value.present?) : value
    end

    def decimal(name)
      value = attribute name
      BigDecimal value.to_s if value.present?
    end
  end
end
