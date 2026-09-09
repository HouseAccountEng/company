require 'test_helper'

class VisitTest < Minitest::Test
  def test_reads_a_visit_and_the_job_it_belongs_to
    visit = Company::Visit.new node: { id: 'visit-01', description: 'Day one',
                                       starts_at: '2026-08-09T14:00:00Z',
                                       ends_at: Time.utc(2026, 8, 9, 16), anytime: false,
                                       job: { id: 'job-01' }, }

    assert_equal 'visit-01', visit.id
    assert_equal 'Day one', visit.description
    assert_equal Time.utc(2026, 8, 9, 14), visit.starts_at
    assert_equal Time.utc(2026, 8, 9, 16), visit.ends_at
    refute visit.anytime?
    assert_equal 'job-01', visit.job.id
  end

  def test_reads_no_end_where_the_platform_left_it_blank
    assert_nil Company::Visit.new(node: { ends_at: '' }).ends_at
  end
end
