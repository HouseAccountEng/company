require 'test_helper'

class AccountTest < Minitest::Test
  def test_reads_the_business_behind_the_credentials
    company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing',
                                           phone: '7044597540', }

    assert_equal 'account-01', company.account.id
    assert_equal 'Acme Plumbing', company.account.name
    assert_equal '7044597540', company.account.phone
  end

  def test_walks_every_job_the_business_holds
    company = Company::Mock.new jobs: [ { id: 'job-01' }, { id: 'job-02' } ]

    assert_equal %w[job-01 job-02], company.account.jobs.map(&:id)
  end

  def test_answers_the_phone_as_ten_digits_and_as_nothing_where_none_is_held
    assert_equal '4562232934', account(phone: '+1 (456) 223-2934').phone
    assert_nil account(phone: '').phone
    assert_nil account(phone: nil).phone
  end

  def test_refuses_a_number_that_is_not_a_north_american_one
    error = assert_raises(Company::Error) { account(phone: '1009003999').phone }

    assert_equal '1009003999 is not a North American number', error.message
    assert_raises(Company::Error) { account(phone: '456').phone }
  end

private

  def account(phone:) = Company::Mock.new(account: { phone: phone }).account
end
