# The account is read through a company, never built by hand, and answers in this gem's words
# whichever platform held them.
RSpec.describe Company::Account do
  it 'reads the business behind the credentials' do
    company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing',
                                           phone: '7044597540', }

    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing',
      phone: '7044597540'
  end

  it 'answers nothing under a reader the platform holds nothing for' do
    expect(Company::Mock.new.account.name).to be_nil
  end

  describe '#phone' do
    it 'answers the same ten digits however the platform wrote them' do
      expect(account(phone: '+1 (456) 223-2934').phone).to eq '4562232934'
      expect(account(phone: '456.223.2934').phone).to eq '4562232934'
    end

    it 'answers nothing where the platform holds none' do
      expect(account(phone: nil).phone).to be_nil
      expect(account(phone: '').phone).to be_nil
      expect(Company::Mock.new.account.phone).to be_nil
    end

    it 'refuses a number that is not a North American one, rather than answering nil' do
      expect { account(phone: '1009003999').phone }.
        to raise_error Company::Error, '1009003999 is not a North American number'
      expect { account(phone: '456').phone }.to raise_error Company::Error
    end
  end

  def account(phone:) = Company::Mock.new(account: { phone: phone }).account

  it 'reads a key whichever way a test wrote it' do
    company = Company::Mock.new account: { 'id' => 'account-01', name: 'Acme Plumbing' }

    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing'
  end
end
