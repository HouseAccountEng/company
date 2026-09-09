require 'test_helper'

# A gem maps the readers its platform spells otherwise than the vocabulary, and leaves the
# rest to read the key of their own name.
class MappedBusiness < Company::Business
  def self.keys = { phone: :phone_number }
end

class MappingTest < Minitest::Test
  def test_reads_a_mapped_reader_off_the_named_key_and_the_rest_off_their_own
    business = MappedBusiness.new node: { name: 'Acme Plumbing', phone_number: '(456) 223-2934' }

    assert_equal 'Acme Plumbing', business.name
    assert_equal '4562232934', business.phone
  end

  def test_names_the_node_keys_a_platform_is_expected_to_answer
    assert_equal %i[id name phone_number], MappedBusiness.node_keys
  end
end
