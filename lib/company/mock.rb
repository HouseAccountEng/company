module Company
  # A company answering from what a test handed it rather than from a platform, and the one
  # includer this gem ships: what {#read} answers, {Company} asks of every other.
  #
  #     company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing' }
  #     company.account.name # => 'Acme Plumbing'
  #
  # Only the reading is mocked: every reader on a record is the same code a real company runs.
  class Mock
    include Company

    # @param account [Hash] business, keyed by what {Account} reads.
    # @param jobs [Array<Hash>] jobs, each keyed by what {Job} reads.
    def initialize(account: {}, jobs: [])
      @account = account
      @jobs = jobs
    end

    # @param type [Class] what to read.
    # @param id [String, nil] ID it is filed under, or nothing for the account.
    # @return [Resource, nil] record built from what was handed over, or nil where none was.
    def read(type, id = nil)
      node = type == Account ? @account : @jobs.find { |job| job[:id] == id }
      type.new node: node, company: self if node
    end
  end
end
