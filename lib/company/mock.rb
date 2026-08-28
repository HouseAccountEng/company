module Company
  # A company answering from what a test handed it rather than from a platform, and the one
  # includer this gem ships: what {#walk} and {#read} answer, {Company} asks of every other.
  #
  #     company = Company::Mock.new jobs: [ { id: 'job-01', scheduled_at: 1.day.ago } ]
  #     company.jobs.past.ids # => %w[job-01]
  #
  # Only the reading is mocked. Narrowing a list, walking it as records or as IDs, and every
  # reader on a record is the same code a real company runs.
  class Mock
    include Company

    # @param account [Hash] the business, keyed by what {Account} reads.
    # @param customers [Array<Hash>] the records of each kind, keyed by what each reads, in
    #   snake_case, and dated with whatever the test gave them: what answers to `past` and
    #   `upcoming` is that.
    def initialize(account: {}, customers: [], locations: [], leads: [], quotes: [], jobs: [],
      visits: [], invoices: [], payments: [], employees: [], availability: [])
      @account = account
      @records = {
        Customer => customers, Location => locations, Lead => leads, Quote => quotes, Job => jobs,
        Visit => visits, Invoice => invoices, Payment => payments, Employee => employees,
        Availability => availability,
      }
    end

    # Every record matching the list, in its order and up to its cut. A condition matches by
    # `===`, so a range covers a moment and anything else has to equal.
    # @param relation [Relation] the list, narrowed as the caller left it.
    # @return [Enumerator::Lazy<Resource>] the records, built only as far as they are walked.
    def walk(relation)
      matched = @records.fetch(relation.type).select { |record| matches? record, relation }
      cut(sorted(matched, relation.sorts), relation.cap).lazy.map do |node|
        relation.type.new node: node, company: self
      end
    end

    # @param type [Class] what to read.
    # @param id [String, nil] the ID it is filed under, or nothing for the account.
    # @return [Resource, nil] the record, or nil where the test handed none under that ID.
    def read(type, id = nil)
      node = type == Account ? @account : @records.fetch(type).find { |it| it[:id] == id }
      type.new node: node, company: self if node
    end

    # A test writes its records the way Ruby writes a Hash.
    def keys = :snake

  private

    def matches?(record, relation)
      relation.conditions.all? { |name, value| value === record[name] }
    end

    def sorted(records, sorts)
      return records if sorts.empty?

      name, direction = sorts.first
      ordered = records.sort_by { |record| record[name] }
      direction == :desc ? ordered.reverse : ordered
    end

    def cut(records, cap) = cap ? records.first(cap) : records
  end
end
