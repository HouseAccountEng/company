require 'test_helper'

class JobTest < Minitest::Test
  def test_reads_a_job_by_the_id_the_company_files_it_under
    company = Company::Mock.new jobs: [ { id: 'job-01', description: 'Furnace tune-up',
                                          created_at: '2026-08-08T11:00:00Z',
                                          scheduled_at: '2026-08-09T14:00:00Z',
                                          amount: 260.0, } ]
    job = company.job 'job-01'

    assert_equal 'job-01', job.id
    assert_equal 'Furnace tune-up', job.description
    assert_equal Time.utc(2026, 8, 8, 11), job.created_at
    assert_equal Time.utc(2026, 8, 9, 14), job.scheduled_at
    assert_nil job.completed_at
    assert_equal 260, job.amount
    assert_instance_of BigDecimal, job.amount
  end
end
