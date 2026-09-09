require 'test_helper'

class LocationTest < Minitest::Test
  def test_reads_where_the_work_happens_and_whose_place_it_is
    location = Company::Location.new node: { id: 'location-01', street: '1 Main St',
                                             city: 'Raleigh', zip: '27601', latitude: 35.77,
                                             longitude: -78.63,
                                             customer: { id: 'customer-01', name: 'Jane',
                                                         surname: 'Doe',
                                                         email: 'jane@example.com',
                                                         phone: '(704) 459-7540', }, }

    assert_equal 'location-01', location.id
    assert_equal '1 Main St', location.street
    assert_equal 'Raleigh', location.city
    assert_equal '27601', location.zip
    assert_in_delta 35.77, location.latitude
    assert_in_delta(-78.63, location.longitude)
    assert_equal 'customer-01', location.customer.id
    assert_equal 'Jane', location.customer.name
    assert_equal 'Doe', location.customer.surname
    assert_equal 'jane@example.com', location.customer.email
    assert_equal '7044597540', location.customer.phone
  end

  def test_reads_a_customer_with_no_dialable_number_as_reachable_by_none
    assert_nil Company::Customer.new(node: { phone: '+44 20 7946 0958' }).phone
  end
end
