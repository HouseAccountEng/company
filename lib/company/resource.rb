module Company
  # What every record shares: the node the platform answered it as, and the company it was
  # read from. Built by the company, never by a caller.
  class Resource
    # @param node [Hash] the record as the platform answered it, or as a test wrote it.
    # @param company [Company] the business it was read from.
    def initialize(company:, node: {})
      @node = node.with_indifferent_access
      @company = company
    end

    # @return [String, nil] the ID the company files the record under.
    def id = attribute :id

  private

    # The record as it was handed over, for a subclass that reads its own lazily to override.
    def node = @node

    # What the platform answers under a reader's name, spelled the way the company's keys are.
    # Deriving a key from a name is the one place this gem leans that way: :snake is a plain
    # lookup, and a company declaring nil declares every reader itself.
    def attribute(name)
      case @company.keys
        when :snake then node[name]
        when :camel then node[name.to_s.camelize :lower]
        else raise NotImplementedError, "#{self.class}##{name} is not declared"
      end
    end
  end
end
