require 'test_helper'

# A gem whose platform nests businesses says which sit directly under this one.
class NestedBusiness < Company::Business
private

  def below = records NestedBusiness, :locations
end

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

  def test_is_its_own_one_subsidiary_where_the_platform_nests_nothing
    business = Company::Business.new node: { id: 'account-01' }

    assert_equal [ 'account-01' ], business.subsidiaries.map(&:id)
  end

  def test_lists_itself_and_every_business_beneath_it_flat_and_in_order
    region = { id: 'region', locations: [ { id: 'springfield' }, { id: 'shelbyville' } ] }
    business = NestedBusiness.new node: { id: 'hq', locations: [ region, { id: 'ogdenville' } ] }

    assert_equal %w[hq region springfield shelbyville ogdenville], business.subsidiaries.map(&:id)
    assert_instance_of NestedBusiness, business.subsidiaries.last
  end

private

  def business(phone:) = Company::Business.new(node: { phone: phone })
end
