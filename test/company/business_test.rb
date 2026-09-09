require 'test_helper'

class BusinessTest < Minitest::Test
  def test_reads_who_the_credentials_belong_to
    business = Company::Business.new node: { 'id' => 'account-01', 'name' => 'Acme Plumbing',
                                             'phone' => '+1 (704) 459-7540', }

    assert_equal 'account-01', business.id
    assert_equal 'Acme Plumbing', business.name
    assert_equal '7044597540', business.phone
  end

  def test_answers_no_phone_where_none_is_held_or_none_can_be_dialed
    assert_nil business(phone: '').phone
    assert_nil business(phone: nil).phone
    assert_nil business(phone: '1009003999').phone
    assert_nil business(phone: '456').phone
  end

private

  def business(phone:) = Company::Business.new(node: { phone: phone })
end
