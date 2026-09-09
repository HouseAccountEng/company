require 'test_helper'

class JobTest < Minitest::Test
  def setup
    lines = [ { id: 'line-01', name: 'Faucet install', quantity: 3.0, amount: 80.0 },
              { name: 'Trip fee' }, ]
    @job = Company::Job.new node: { id: 'job-01', description: 'Furnace tune-up',
                                    instructions: 'Ring twice', quote_id: 'quote-01',
                                    quote_amount: 240.0, created_at: '2026-08-08T11:00:00Z',
                                    scheduled_at: '2026-08-09T14:00:00Z', amount: '260.0',
                                    lines: lines, location: { id: 'location-01' }, }
  end

  def test_reads_a_job_as_the_platform_answered_it
    assert_equal 'job-01', @job.id
    assert_equal 'Ring twice', @job.instructions
    assert_equal 'quote-01', @job.quote_id
    assert_equal 240, @job.quote_amount
    assert_instance_of BigDecimal, @job.quote_amount
    assert_equal Time.utc(2026, 8, 8, 11), @job.created_at
    assert_equal Time.utc(2026, 8, 9, 14), @job.scheduled_at
    assert_nil @job.completed_at
    assert_equal 260, @job.amount
    assert_instance_of BigDecimal, @job.amount
    assert_equal 'location-01', @job.location.id
  end

  def test_sums_a_job_up_by_its_lines_then_its_description_then_its_id
    assert_equal '3 Faucet install and Trip fee', @job.summary
    assert_equal 'Furnace tune-up', job(description: 'Furnace tune-up').summary
    assert_equal 'job-02', job(description: '').summary
  end

  def test_names_the_node_keys_a_platform_is_expected_to_answer_a_job_with
    assert_equal %i[id quote_id quote_amount description instructions created_at scheduled_at
                    completed_at amount], Company::Job.node_keys
  end

  def test_reads_nothing_where_the_platform_answered_nothing
    job = job description: nil

    assert_nil job.quote_amount
    assert_nil job.location
    assert_equal [], job.lines
  end

private

  def job(description:) = Company::Job.new(node: { id: 'job-02', description: description })
end
