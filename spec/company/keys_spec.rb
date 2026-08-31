# What a gem says about how its platform spells keys decides which readers it has to declare.
# Jobber writes camelCase, so a reader whose name matches a key goes undeclared there.
class CamelCompany
  include Company

  def keys = :camel

  def read(type, _id = nil)
    type.new node: { 'name' => 'Acme Plumbing', 'timeZone' => 'America/New_York' }, company: self
  end
end

# A gem that says nothing promises to declare every reader itself, matching key or not.
class SilentCompany
  include Company

  def read(type, _id = nil) = type.new(node: { name: 'Acme Plumbing' }, company: self)
end

RSpec.describe Company, '#keys' do
  it 'reads a camelCase key under a snake_case reader where the gem said :camel' do
    expect(CamelCompany.new.account).to have_attributes name: 'Acme Plumbing',
      time_zone: 'America/New_York', phone: nil
  end

  it 'reads nothing for a gem that said nothing, so an undeclared reader is loud' do
    expect { SilentCompany.new.account.name }.
      to raise_error NotImplementedError, 'Company::Account#name is not declared'
  end
end
