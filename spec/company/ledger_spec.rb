# The records that carry a moment and a sum: what was booked, what was billed, what was paid,
# and when the business is free.
RSpec.describe Company::Resource do
  let(:now) { Time.now }
  let(:employee) { { id: 'employee-01', first_name: 'Ada' } }

  it 'reads the account' do
    account = Company::Account.new attributes: { id: 'account-01', name: 'Acme Plumbing',
      phone: '7044597540', email: 'hi@acme.test', website: 'https://acme.test',
      time_zone: 'America/New_York', location: { city: 'Charlotte' }, }

    expect(account).to have_attributes id: 'account-01', name: 'Acme Plumbing',
      phone: '7044597540', email: 'hi@acme.test', website: 'https://acme.test',
      time_zone: 'America/New_York'
    expect(account.location.city).to eq 'Charlotte'
  end

  it 'reads a job as booked and as done' do
    job = Company::Job.new attributes: { instructions: 'Ring twice', status: 'archived',
      scheduled_at: now, completed_at: now + 3600, created_at: now - 86_400, updated_at: now, }

    expect(job).to have_attributes instructions: 'Ring twice', status: 'archived',
      scheduled_at: now, completed_at: now + 3600, created_at: now - 86_400, updated_at: now
  end

  it 'reads a visit as a stop on a job' do
    visit = Company::Visit.new attributes: { job_id: 'job-01', title: 'Day one', starts_at: now,
      ends_at: now + 7200, all_day: false, confirmed: true, job: { id: 'job-01' },
      employees: [ employee ], }

    expect(visit).to have_attributes job_id: 'job-01', title: 'Day one', starts_at: now,
      ends_at: now + 7200, all_day?: false, confirmed?: true
    expect(visit.job.id).to eq 'job-01'
    expect(visit.employees.map(&:name)).to eq %w[Ada]
  end

  it 'reads a quote as a price sent' do
    quote = Company::Quote.new attributes: { customer_id: 'customer-01', lead_id: 'lead-01',
      status: 'sent', total: 240.0, sent_at: now, customer: { id: 'customer-01' }, }

    expect(quote).to have_attributes customer_id: 'customer-01', lead_id: 'lead-01',
      status: 'sent', total: 240.0, sent_at: now
    expect(quote.customer.id).to eq 'customer-01'
    expect(quote.lines).to be_empty
  end

  it 'reads an invoice as a bill' do
    invoice = Company::Invoice.new attributes: { job_id: 'job-01', customer_id: 'customer-01',
      number: '1042', status: 'sent', total: 260.0, balance: 60.0, issued_at: now,
      due_at: now + 86_400, job: { id: 'job-01' }, }

    expect(invoice).to have_attributes job_id: 'job-01', customer_id: 'customer-01',
      number: '1042', status: 'sent', total: 260.0, balance: 60.0, issued_at: now,
      due_at: now + 86_400
    expect(invoice.job.id).to eq 'job-01'
  end

  it 'reads a payment as money against a bill' do
    payment = Company::Payment.new attributes: { invoice_id: 'invoice-01',
      customer_id: 'customer-01', amount: 200.0, method: 'card', paid_at: now,
      invoice: { id: 'invoice-01' }, }

    expect(payment).to have_attributes invoice_id: 'invoice-01', customer_id: 'customer-01',
      amount: 200.0, method: 'card', paid_at: now
    expect(payment.invoice.id).to eq 'invoice-01'
  end

  it 'reads a window the business is free in' do
    window = Company::Availability.new attributes: { starts_at: now, ends_at: now + 7200,
      available: true, employees: [ employee ], }

    expect(window).to have_attributes starts_at: now, ends_at: now + 7200, available?: true
    expect(window.employees.map(&:id)).to eq %w[employee-01]
  end

  it 'reads a lead as where the work would happen' do
    lead = Company::Lead.new attributes: { location: { street: '1 Main St' }, created_at: now }

    expect(lead.location.street).to eq '1 Main St'
    expect(lead.created_at).to eq now
  end

  it 'reads a customer as the places and the bills on their file' do
    customer = Company::Customer.new attributes: { id: 'customer-01', company_name: 'Acme',
      created_at: now, }
    location = Company::Location.new attributes: { customer: { id: 'customer-01' } }

    expect(customer).to have_attributes company_name: 'Acme', created_at: now
    expect(location.customer.id).to eq 'customer-01'
  end
end
