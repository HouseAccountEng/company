module Company
  # What every record shares: the node the platform answered it as, and the company it was
  # read from. Built by the company, never by a caller.
  class Resource
    # The node keys the platform spells otherwise than the vocabulary, by the reader they
    # answer: `{ phone: :phone_number }` reads {Account#phone} off `phone_number`. A gem
    # declares its own; a reader left out reads the key of its own name.
    # @return [Hash] the reader-to-key exceptions, empty where every name is its key.
    def self.keys = {}

    # @param node [Hash] the record as the platform answered it, or as a test wrote it.
    # @param company [Company] the business it was read from.
    def initialize(company:, node: {})
      @node = node.with_indifferent_access
      @company = company
    end

    # @return [String, nil] the ID the company files the record under.
    def id = attribute :id

  private

    # The record as it was handed over, for a subclass that reads its own lazily to override
    # -- keeping it readable under either kind of key, as {#attribute} asks by name.
    def node = @node

    # What the platform answers under a reader's name, or under the key the gem mapped it to.
    def attribute(name) = node[self.class.keys.fetch(name, name)]
  end
end
