require 'test_helper'

class LineTest < Minitest::Test
  def test_reads_a_line_as_how_many_of_what
    line = Company::Line.new node: { id: 'line-01', name: 'Faucet install',
                                     description: 'Replace washers', quantity: 3.0,
                                     amount: 80.0, }

    assert_equal 'line-01', line.id
    assert_equal 'Replace washers', line.description
    assert_equal 3, line.quantity
    assert_equal 80, line.amount
    assert_instance_of BigDecimal, line.amount
  end

  def test_keeps_a_fractional_quantity_and_reads_none_where_the_platform_holds_none
    assert_equal 2.5, Company::Line.new(node: { quantity: 2.5 }).quantity
    assert_nil Company::Line.new(node: { name: 'Trip fee' }).quantity
  end
end
