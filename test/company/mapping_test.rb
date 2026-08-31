require 'test_helper'

# A gem maps the readers its platform spells otherwise than the vocabulary, and leaves the
# rest to read the key of their own name.
class MappedAccount < Company::Account
  def self.keys = { phone: :phone_number }
end

# The company whose platform answers those keys.
class MappedCompany
  include Company

  def read(_type, _id = nil)
    MappedAccount.new company: self, node: { name: 'Acme Plumbing',
                                             phone_number: '+1 (456) 223-2934', }
  end
end

class MappingTest < Minitest::Test
  def test_reads_a_mapped_reader_off_the_named_key_and_the_rest_off_their_own
    account = MappedCompany.new.account

    assert_equal 'Acme Plumbing', account.name
    assert_equal '4562232934', account.phone
  end
end
