require 'test_helper'

class JobTest < Minitest::Test
  def setup
    lines = [ { id: 'line-01', name: 'Faucet install', description: 'Replace washers',
                quantity: 3.0, amount: 80.0, },
              { name: 'Trip fee' }, ]
    company = Company::Mock.new jobs: [ { id: 'job-01', description: 'Furnace tune-up',
                                          created_at: '2026-08-08T11:00:00Z',
                                          scheduled_at: '2026-08-09T14:00:00Z',
                                          amount: 260.0, lines: lines,
                                          visits: [ { id: 'visit-01', description: 'Day one',
                                                      starts_at: '2026-08-09T14:00:00Z',
                                                      ends_at: '2026-08-09T16:00:00Z',
                                                      all_day: false, } ], } ]
    @job = company.job 'job-01'
  end

  def test_reads_a_job_by_the_id_the_company_files_it_under
    assert_equal 'job-01', @job.id
    assert_equal 'Furnace tune-up', @job.description
    assert_equal Time.utc(2026, 8, 8, 11), @job.created_at
    assert_equal Time.utc(2026, 8, 9, 14), @job.scheduled_at
    assert_nil @job.completed_at
    assert_equal 260, @job.amount
    assert_instance_of BigDecimal, @job.amount
  end

  def test_reads_the_lines_a_job_is_billed_as
    line, fee = @job.lines

    assert_equal 'line-01', line.id
    assert_equal 'Faucet install', line.name
    assert_equal 'Replace washers', line.description
    assert_equal 3, line.quantity
    assert_equal 80, line.amount
    assert_instance_of BigDecimal, line.amount
    assert_equal 'Trip fee', fee.name
    assert_nil fee.quantity
  end

  def test_reads_the_visits_a_job_is_booked_as
    visit = @job.visits.first

    assert_equal 'visit-01', visit.id
    assert_equal 'Day one', visit.description
    assert_equal Time.utc(2026, 8, 9, 14), visit.starts_at
    assert_equal Time.utc(2026, 8, 9, 16), visit.ends_at
    refute visit.all_day?
  end
end
