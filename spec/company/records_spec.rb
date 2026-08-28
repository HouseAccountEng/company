# What each kind of record reads, and what each stands in with where a platform holds nothing.
RSpec.describe Company::Resource do
  let(:company) { Company::Mock.new }

  it 'names a customer by whichever names the company holds, then by the business they are' do
    expect(customer(first_name: 'Jane', last_name: 'Doe').name).to eq 'Jane Doe'
    expect(customer(first_name: 'Jane', last_name: '').name).to eq 'Jane'
    expect(customer(company_name: 'Acme').name).to eq 'Acme'
    expect(customer(company_name: '').name).to be_nil
  end

  it 'reads a person the same way whoever they are' do
    person = { first_name: 'Ada', last_name: 'Lovelace', email: 'ada@example.com',
               phone: '5550000001', }
    employee = Company::Employee.new attributes: person.merge(role: 'Technician')
    lead = Company::Lead.new attributes: person.merge(source: 'Web', status: 'New', notes: 'Leak')

    expect(employee).to have_attributes name: 'Ada Lovelace', email: 'ada@example.com',
      phone: '5550000001', role: 'Technician'
    expect(lead).to have_attributes name: 'Ada Lovelace', source: 'Web', status: 'New',
      notes: 'Leak'
  end

  it 'names an untitled record by its ID, so a list always has something to show' do
    expect(Company::Job.new(attributes: { id: 'job-01', title: 'Tune-up' }).name).to eq 'Tune-up'
    expect(Company::Job.new(attributes: { id: 'job-01', title: '' }).name).to eq 'job-01'
    expect(Company::Visit.new(attributes: { id: 'visit-01' }).name).to eq 'visit-01'
  end

  it 'sums a job up by its lines, and by its name where it has none' do
    lines = [ { quantity: 3.0, name: 'Faucet install' }, { quantity: 2.5, name: 'Hours' },
              { name: 'Trip fee' }, ]
    job = Company::Job.new attributes: { id: 'job-01', title: 'Tune-up', lines: lines,
                                         total: 260.0, }

    expect(job.lines.map(&:to_s)).to eq [ '3 Faucet install', '2.5 Hours', 'Trip fee' ]
    expect(job.summary).to eq '3 Faucet install, 2.5 Hours, and Trip fee'
    expect(job.total).to eq 260.0
    expect(Company::Job.new(attributes: { id: 'job-01' }).summary).to eq 'job-01'
  end

  it 'reads a line whole' do
    line = Company::Line.new attributes: { name: 'Valve', description: 'Brass', quantity: 2.0,
                                           unit_price: 40.0, total: 80.0, }

    expect(line).to have_attributes name: 'Valve', description: 'Brass', quantity: 2,
      unit_price: 40.0, total: 80.0
  end

  it 'writes a location on one line from whatever parts of it the company holds' do
    full = { street: '1 Main St', city: 'Raleigh', state: 'NC', zip: '27601',
             latitude: 35.77, longitude: -78.63, customer_id: 'customer-01', }

    expect(Company::Location.new(attributes: full)).to have_attributes(
      street: '1 Main St', city: 'Raleigh', state: 'NC', zip: '27601', latitude: 35.77,
      longitude: -78.63, customer_id: 'customer-01', to_s: '1 Main St, Raleigh, NC 27601',
    )
    expect(Company::Location.new(attributes: { city: 'Raleigh', zip: '27601' }).to_s).
      to eq 'Raleigh, 27601'
  end

  def customer(**attributes) = Company::Customer.new(attributes: attributes)

  it 'brings a record another names back beside it only where it came back with it' do
    job = Company::Job.new attributes: { id: 'job-01', customer_id: 'customer-01',
      location_id: 'location-01', quote_id: 'quote-01', customer: { id: 'customer-01' }, }

    expect(job.customer.id).to eq 'customer-01'
    expect(job.location).to be_nil
    expect(job).to have_attributes customer_id: 'customer-01', location_id: 'location-01',
      quote_id: 'quote-01'
  end

  it 'hangs the records that name one off it, narrowed by its ID' do
    job = Company::Job.new attributes: { id: 'job-01' }, company: company
    customer = Company::Customer.new attributes: { id: 'customer-01' }, company: company
    quote = Company::Quote.new attributes: { id: 'quote-01' }, company: company
    invoice = Company::Invoice.new attributes: { id: 'invoice-01' }, company: company
    employee = Company::Employee.new attributes: { id: 'employee-01' }, company: company

    expect(job.visits.conditions).to eq job_id: 'job-01'
    expect(job.invoices.conditions).to eq job_id: 'job-01'
    expect(customer.locations.conditions).to eq customer_id: 'customer-01'
    expect(customer.invoices.conditions).to eq customer_id: 'customer-01'
    expect(quote.jobs.conditions).to eq quote_id: 'quote-01'
    expect(invoice.payments.conditions).to eq invoice_id: 'invoice-01'
    expect(employee.visits.conditions).to eq employee_id: 'employee-01'
  end
end
