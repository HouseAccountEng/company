module Company
  # What every record shares: the node the platform answered it as, and the company it was
  # read from. Built by the company, never by a caller: a record is reached through a list.
  class Resource
    # @param company [Company] the business the records are read from.
    # @return [Relation] every record of this kind the business holds.
    def self.all(company) = Relation.new type: self, company: company

    # The moment {Relation#past} and {Relation#upcoming} split a list of these at. When a record
    # was opened, unless the kind says otherwise.
    # @return [Symbol] the attribute a window narrows by.
    def self.window = :created_at

    # @param node [Hash] the record as the platform answered it, or as a test wrote it.
    # @param company [Company] the business it was read from.
    def initialize(node:, company:)
      @node = node.with_indifferent_access
      @company = company
    end

    # @return [String, nil] the ID the company files the record under.
    def id = attribute :id

  private

    # What the platform answers under a reader's name, spelled the way the company's keys are.
    # Deriving a key from a name is the one place this gem leans that way: :snake is a plain
    # lookup, and a company declaring nil declares every reader itself.
    def attribute(name)
      case @company.keys
        when :snake then @node[name]
        when :camel then @node[name.to_s.camelize :lower]
        else raise NotImplementedError, "#{self.class}##{name} is not declared"
      end
    end

    # A moment whichever way it arrived: a Time from a test, an ISO 8601 string from a platform,
    # and nothing from an empty answer.
    def time(name)
      value = attribute name
      value.is_a?(String) ? (Time.iso8601 value if value.present?) : value
    end

    # The record another names, where the list was asked to bring it back beside each record.
    def record(type, key) = (type.new node: @node[key], company: @company if @node[key])

    # The records another carries, in the order the company holds them.
    def records(type, key) = Array(@node[key]).map { |node| type.new node: node, company: @company }
  end
end
