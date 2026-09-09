require 'test_helper'

# A gem answers the readers its platform offers, and leaves the rest to raise.
class JobsAccount < Company::Account
  def jobs = [ Company::Job.new(node: { id: 'job-01' }) ]
end

class AccountTest < Minitest::Test
  def test_refuses_every_reader_a_gem_leaves_out_naming_the_gem_and_the_reader
    account = Company::Account.new

    error = assert_raises(NotImplementedError) { account.business }
    assert_equal 'Company::Account does not answer business', error.message
    assert_raises(NotImplementedError) { account.leads }
    assert_raises(NotImplementedError) { account.quotes }
    assert_raises(NotImplementedError) { account.jobs }
    assert_raises(NotImplementedError) { account.visits }
    assert_raises(NotImplementedError) { account.invoices }
  end

  def test_answers_the_reader_a_gem_overrides_and_refuses_the_rest_in_its_own_name
    account = JobsAccount.new

    assert_equal %w[job-01], account.jobs.map(&:id)
    error = assert_raises(NotImplementedError) { account.visits }
    assert_equal 'JobsAccount does not answer visits', error.message
  end
end
