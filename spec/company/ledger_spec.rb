# The records that carry a moment and a sum: what was booked, what was billed, what was paid,
# and when the business is free. A moment reads as a Time however the platform wrote it.
RSpec.describe Company::Resource do
  let(:now) { Time.now.round }
  let(:employee) { { id: 'employee-01', first_name: 'Ada' } }
  let(:company) do
    Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing', phone: '7044597540',
                                 email: 'hi@acme.test', website: 'https://acme.test',
                                 time_zone: 'America/New_York', location: { city: 'Charlotte' }, },
      jobs: [ { id: 'job-01', instructions: 'Ring twice', status: 'archived',
                scheduled_at: '2026-08-09T14:00:00Z', completed_at: '', created_at: now,
                updated_at: now, } ],
      visits: [ { id: 'visit-01', job_id: 'job-01', title: 'Day one', starts_at: now,
                  ends_at: now + 7200, all_day: false, confirmed: true, job: { id: 'job-01' },
                  employees: [ employee ], } ],
      quotes: [ { id: 'quote-01', customer_id: 'customer-01', lead_id: 'lead-01', status: 'sent',
                  total: 240.0, sent_at: now, customer: { id: 'customer-01' }, } ],
      invoices: [ { id: 'invoice-01', job_id: 'job-01', customer_id: 'customer-01', number: '1042',
                    status: 'sent', total: 260.0, balance: 60.0, issued_at: now,
                    due_at: now + 86_400, job: { id: 'job-01' }, } ],
      payments: [ { id: 'payment-01', invoice_id: 'invoice-01', customer_id: 'customer-01',
                    amount: 200.0, method: 'card', paid_at: now, invoice: { id: 'invoice-01' }, } ],
      availability: [ { starts_at: now, ends_at: now + 7200, available: true,
                        employees: [ employee ], } ],
      leads: [ { id: 'lead-01', location: { street: '1 Main St' }, created_at: now } ],
      customers: [ { id: 'customer-01', company_name: 'Acme', created_at: now } ]
  end

  it 'reads the account' do
    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing',
      phone: '7044597540', email: 'hi@acme.test', website: 'https://acme.test',
      time_zone: 'America/New_York'
    expect(company.account.location.city).to eq 'Charlotte'
  end

  it 'reads a job as booked and as done, a moment as a Time and an empty one as nothing' do
    expect(company.jobs.first).to have_attributes instructions: 'Ring twice', status: 'archived',
      scheduled_at: Time.utc(2026, 8, 9, 14), completed_at: nil, created_at: now, updated_at: now
  end

  it 'reads a visit as a stop on a job' do
    visit = company.visits.first

    expect(visit).to have_attributes job_id: 'job-01', title: 'Day one', starts_at: now,
      ends_at: now + 7200, all_day?: false, confirmed?: true
    expect(visit.job.id).to eq 'job-01'
    expect(visit.employees.map(&:name)).to eq %w[Ada]
  end

  it 'reads a quote as a price sent' do
    quote = company.quotes.first

    expect(quote).to have_attributes customer_id: 'customer-01', lead_id: 'lead-01',
      status: 'sent', total: 240.0, sent_at: now
    expect(quote.customer.id).to eq 'customer-01'
    expect(quote.lines).to be_empty
    expect(quote.jobs.conditions).to eq quote_id: 'quote-01'
  end

  it 'reads an invoice as a bill' do
    invoice = company.invoices.first

    expect(invoice).to have_attributes job_id: 'job-01', customer_id: 'customer-01',
      number: '1042', status: 'sent', total: 260.0, balance: 60.0, issued_at: now,
      due_at: now + 86_400
    expect(invoice.job.id).to eq 'job-01'
    expect(invoice.payments.conditions).to eq invoice_id: 'invoice-01'
  end

  it 'reads a payment as money against a bill' do
    payment = company.payments.first

    expect(payment).to have_attributes invoice_id: 'invoice-01', customer_id: 'customer-01',
      amount: 200.0, method: 'card', paid_at: now
    expect(payment.invoice.id).to eq 'invoice-01'
  end

  it 'reads a window the business is free in' do
    window = company.availability.first

    expect(window).to have_attributes starts_at: now, ends_at: now + 7200, available?: true
    expect(window.employees.map(&:id)).to eq %w[employee-01]
  end

  it 'reads a lead as where the work would happen, and a customer as when they were opened' do
    expect(company.leads.first.location.street).to eq '1 Main St'
    expect(company.leads.first.created_at).to eq now
    expect(company.customers.first).to have_attributes company_name: 'Acme', created_at: now
  end
end
