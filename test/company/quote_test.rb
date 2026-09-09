require 'test_helper'

class QuoteTest < Minitest::Test
  def test_reads_a_quote_and_the_lead_it_answers
    quote = Company::Quote.new node: { id: 'quote-01', lead_id: 'lead-01', amount: '240.0' }

    assert_equal 'quote-01', quote.id
    assert_equal 'lead-01', quote.lead_id
    assert_equal 240, quote.amount
    assert_instance_of BigDecimal, quote.amount
  end
end
