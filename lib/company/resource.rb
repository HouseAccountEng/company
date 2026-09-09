module Company
  # What every record shares: the node the platform answered it as. Built by the gem that read
  # it, never by a caller.
  class Resource
    # The node keys the platform spells otherwise than the vocabulary, by the reader they
    # answer: `{ phone: :phone_number }` reads {Business#phone} off `phone_number`. A gem
    # declares its own; a reader left out reads the key of its own name.
    # @return [Hash] reader-to-key exceptions, empty where every name is its key.
    def self.keys = {}

    # The keys a platform is expected to answer a node with: each attribute the kind reads,
    # through {.keys}, so a gem asks its platform for exactly these and writes none by hand.
    # @return [Array<Symbol>] node keys, in the order the attributes are read.
    def self.node_keys = attributes.map { |name| keys.fetch name, name }

    # @param node [Hash] record as the platform answered it, under either kind of key.
    def initialize(node: {})
      @node = node.with_indifferent_access
    end

    # @return [String] ID the platform files the record under.
    def id = attribute :id

  private

    def attribute(name) = @node[self.class.keys.fetch(name, name)]

    def time(name)
      value = attribute name
      value.is_a?(String) ? (Time.iso8601 value if value.present?) : value
    end

    def decimal(name)
      value = attribute name
      BigDecimal value.to_s if value.present?
    end

    def record(type, key) = (type.new node: @node[key] if @node[key])

    def records(type, key) = Array(@node[key]).map { |each| type.new node: each }
  end
end
