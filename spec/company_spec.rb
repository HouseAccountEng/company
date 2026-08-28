RSpec.describe Company do
  it 'names the version it was built as' do
    expect(Company::VERSION).not_to be_nil
  end
end
