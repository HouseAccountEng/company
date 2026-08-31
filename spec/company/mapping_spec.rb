# A gem maps the readers its platform spells otherwise than the vocabulary, and leaves the
# rest to read the key of their own name.
class MappedAccount < Company::Account
  def self.keys = { phone: :phone_number, email: :support_email }
end

# The company whose platform answers those keys.
class MappedCompany
  include Company

  def read(_type, _id = nil)
    MappedAccount.new company: self, node: { 'name' => 'Acme Plumbing',
                                             'phone_number' => '7044597540',
                                             'support_email' => 'hi@acme.example', }
  end
end

RSpec.describe Company::Resource, '.keys' do
  it 'reads a mapped reader off the key the gem named, and the rest off their own name' do
    expect(MappedCompany.new.account).to have_attributes name: 'Acme Plumbing',
      phone: '7044597540', email: 'hi@acme.example'
  end
end
