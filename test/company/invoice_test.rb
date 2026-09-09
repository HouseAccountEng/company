require 'test_helper'

class InvoiceTest < Minitest::Test
  def test_dates_the_fulfillment_by_the_finish_where_the_platform_dated_it
    invoice = Company::Invoice.new node: { id: 'invoice-01', job_id: 'job-01', amount: '40.30',
                                           completed_at: '2026-08-09T16:00:00Z',
                                           issued_at: '2026-08-10T09:00:00Z', }

    assert_equal 'invoice-01', invoice.id
    assert_equal 'job-01', invoice.job_id
    assert_equal BigDecimal('40.30'), invoice.amount
    assert_equal Time.utc(2026, 8, 9, 16), invoice.fulfilled_at
  end

  def test_dates_the_fulfillment_by_the_issue_where_the_work_is_undated
    invoice = Company::Invoice.new node: { issued_at: '2026-08-10T09:00:00Z' }

    assert_equal Time.utc(2026, 8, 10, 9), invoice.fulfilled_at
  end
end
