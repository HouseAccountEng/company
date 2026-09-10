require 'test_helper'

class LeadsTest < Minitest::Test
  def test_refuses_to_file_a_lead_until_a_gem_says_how
    error = assert_raises(NotImplementedError) do
      Company::Leads.new.create name: 'Ada', surname: nil, phone: nil, email: nil, address: nil,
        description: 'Fix the sink', notes: nil, source: nil
    end

    assert_equal 'Company::Leads does not file a lead', error.message
  end
end
