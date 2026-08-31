# The account is read through a company, never built by hand, and answers in this gem's words
# whichever platform held them.
RSpec.describe Company::Account do
  it 'reads the business behind the credentials' do
    company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing',
                                           phone: '7044597540', email: 'hi@acme.example', }

    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing',
      phone: '7044597540', email: 'hi@acme.example'
  end

  it 'answers nothing under a reader the platform holds nothing for' do
    expect(Company::Mock.new.account.name).to be_nil
  end

  it 'reads a key whichever way a test wrote it' do
    company = Company::Mock.new account: { 'id' => 'account-01', name: 'Acme Plumbing' }

    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing'
  end
end
