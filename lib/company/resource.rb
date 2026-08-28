module Company
  # What every record shares: its attributes in this gem's words, whichever platform answered
  # them, and the company it was read from, for the lists that hang off it.
  class Resource
    # @param company [Company] the business the records are read from.
    # @return [Relation] every record of this kind the business holds.
    def self.all(company) = Relation.new type: self, company: company

    # The moment {Relation#past} and {Relation#upcoming} split a list of these at. When a record
    # was opened, unless the kind says otherwise.
    # @return [Symbol] the attribute a window narrows by.
    def self.window = :created_at

    # @param attributes [Hash] the record, keyed by the names this gem reads it by.
    # @param company [Company, nil] the business it was read from.
    def initialize(attributes: {}, company: nil)
      @attributes = attributes
      @company = company
    end

    # @return [String, nil] the ID the company files the record under.
    def id = @attributes[:id]

  private

    # The record another names, where the list was asked to bring it back beside each record.
    def record(type, key)
      type.new attributes: @attributes[key], company: @company if @attributes[key]
    end

    # The records another carries, in the order the company holds them.
    def records(type, key)
      Array(@attributes[key]).map { |each| type.new attributes: each, company: @company }
    end
  end
end
