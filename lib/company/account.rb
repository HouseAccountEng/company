module Company
  # The gateway a set of credentials opens on a platform: the business they belong to and the
  # records it holds. A gem subclasses it and answers what its platform offers; a reader it
  # leaves out raises NotImplementedError.
  class Account
    # @return [Business] business the credentials belong to.
    def business = unanswered :business

    # @return [Collection] jobs of the business, each a {Job}; a platform may also `find` one.
    def jobs = unanswered :jobs

    # @return [Collection] visits of the business, each a {Visit}; a platform may also `find` one.
    def visits = unanswered :visits

    # @return [#find] quotes of the business, each a {Quote}: `find` reads one by ID.
    def quotes = unanswered :quotes

    # @return [Leads] leads of the business: `create` files one.
    def leads = unanswered :leads

    # @return [#find] invoices of the business, each an {Invoice}: `find` reads one by ID.
    def invoices = unanswered :invoices

  private

    def unanswered(name) = raise NotImplementedError, "#{self.class} does not answer #{name}"
  end
end
