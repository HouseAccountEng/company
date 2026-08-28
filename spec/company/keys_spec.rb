# What a gem says about how its platform spells keys decides which readers it has to declare.
# Jobber writes camelCase, so a reader whose name matches a key goes undeclared there.
class CamelCompany
  include Company

  def keys = :camel

  def walk(relation)
    node = { 'firstName' => 'Jane', 'lastName' => 'Doe', 'createdAt' => '2026-08-09T14:00:00Z' }
    [ relation.type.new(node: node, company: self) ]
  end
end

# A gem that says nothing promises to declare every reader itself, matching key or not.
class SilentCompany
  include Company

  def walk(relation) = [ relation.type.new(node: { first_name: 'Jane' }, company: self) ]
end

RSpec.describe Company, '#keys' do
  it 'reads a camelCase key under a snake_case reader where the gem said :camel' do
    customer = CamelCompany.new.customers.first

    expect(customer).to have_attributes first_name: 'Jane', last_name: 'Doe', name: 'Jane Doe',
      created_at: Time.utc(2026, 8, 9, 14), email: nil
  end

  it 'reads nothing for a gem that said nothing, so an undeclared reader is loud' do
    customer = SilentCompany.new.customers.first

    expect { customer.first_name }.
      to raise_error NotImplementedError, 'Company::Customer#first_name is not declared'
  end

  it 'reads a snake_case key whichever way it was written where the gem said :snake' do
    company = Company::Mock.new customers: [ { id: 'customer-01', 'first_name' => 'Jane' } ]

    expect(company.customers.first).to have_attributes id: 'customer-01', first_name: 'Jane'
  end
end
