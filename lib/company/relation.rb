module Company
  # Every record of one kind a company holds, and what a caller narrowed, ordered and cut the
  # list to. Nothing is read until the walk starts, so chaining costs no request at all.
  class Relation
    include Enumerable

    # @param type [Class] what each record is read as.
    # @param company [Company] the business the records are read from.
    def initialize(type:, company:, conditions: {}, sorts: {}, cap: nil, inclusions: [])
      @type = type
      @company = company
      @conditions = conditions
      @sorts = sorts
      @cap = cap
      @inclusions = inclusions
    end

    # What the list was narrowed to, ordered by, cut at and asked to bring back beside each
    # record, for the company walking it.
    attr_reader :type, :conditions, :sorts, :cap, :inclusions

    # Every record in the list, one at a time, read only as far as the caller walks.
    def each(&) = @company.walk(self).each(&)

    # Shadows Enumerable#find on purpose, the way Active Record does: a record is reached by the
    # ID the company files it under, not by asking every record whether it is the one.
    # @param id [String] the ID the company files the record under.
    # @return [Resource, nil] nil where the company has none under that ID.
    def find(id) = @company.read @type, id

    # The ID each record is filed under and nothing else about it: the cheapest question a
    # list can be walked with, and the one to ask where every record is then read on its own.
    # @return [Array<String>] every ID in the list.
    def ids = @company.ids self

    # @param conditions [Hash] an attribute, and the value it equals or the range it falls in.
    # @return [Relation] the same list, narrowed to the records matching these too.
    def where(**conditions) = narrowed conditions: @conditions.merge(conditions)

    # @param sorts [Hash] an attribute, and :asc or :desc.
    # @return [Relation] the same list, in this order.
    def order(**sorts) = narrowed sorts: sorts

    # @param count [Integer] how many records to stop after.
    # @return [Relation] the same list, cut there.
    def limit(count) = narrowed cap: count

    # @param names [Array<Symbol>] what to bring back beside each record, which otherwise
    #   arrives only where the company answers it unasked.
    # @return [Relation] the same list, asking for those too.
    def includes(*names) = narrowed inclusions: @inclusions | names

    # @param within [ActiveSupport::Duration, Numeric, nil] how far back to look, or nil for as
    #   far back as the company goes.
    # @return [Relation] the same list, narrowed to what is dated before now.
    def past(within = nil)
      now = Time.now
      where @type.window => (now - within if within)..now
    end

    # @param within [ActiveSupport::Duration, Numeric, nil] how far ahead to look, or nil for as
    #   far ahead as the company is booked.
    # @return [Relation] the same list, narrowed to what is dated from now on.
    def upcoming(within = nil)
      now = Time.now
      where @type.window => now..(now + within if within)
    end

  private

    # The two halves of a schedule are split at the moment they are asked for, and a window's
    # far end is measured from that same moment, so nothing crosses a boundary between pages.
    def narrowed(conditions: @conditions, sorts: @sorts, cap: @cap, inclusions: @inclusions)
      Relation.new type: @type, company: @company, conditions: conditions, sorts: sorts,
        cap: cap, inclusions: inclusions
    end
  end
end
