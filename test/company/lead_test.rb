require 'test_helper'

class LeadTest < Minitest::Test
  def test_reads_a_lead_and_the_customer_it_was_filed_for
    lead = Company::Lead.new node: { id: 'lead-01', customer_id: 'customer-01' }

    assert_equal 'lead-01', lead.id
    assert_equal 'customer-01', lead.customer_id
  end
end
