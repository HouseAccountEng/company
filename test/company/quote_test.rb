require 'test_helper'

class QuoteTest < Minitest::Test
  def test_reads_a_quote_and_what_it_comes_to
    quote = Company::Quote.new node: { id: 'quote-01', amount: '240.0' }

    assert_equal 'quote-01', quote.id
    assert_equal 240, quote.amount
    assert_instance_of BigDecimal, quote.amount
  end
end
