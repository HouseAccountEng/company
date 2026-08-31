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

    # @param account [Hash] the business, keyed by what {Account} reads.
    def initialize(account: {})
      @account = account
    end

    # @param type [Class] what to read.
    # @return [Resource] the record, built from what the test handed over.
    def read(type, _id = nil) = type.new node: @account, company: self
  end
end
