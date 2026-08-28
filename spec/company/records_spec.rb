# What each kind of record reads, and what each stands in with where a platform holds nothing.
RSpec.describe Company::Resource do
  let(:company) do
    Company::Mock.new customers: customers, employees: [ person.merge(id: 'employee-01',
                                                                       role: 'Technician') ],
      leads: [ person.merge(id: 'lead-01', source: 'Web', status: 'New', notes: 'Leak') ],
      jobs: jobs, locations: locations
  end
  let(:person) { { first_name: 'Ada', last_name: 'Lovelace', email: 'ada@example.com',
                   phone: '5550000001', } }
  let(:customers) do
    [ { id: 'customer-01', first_name: 'Jane', last_name: 'Doe' },
      { id: 'customer-02', first_name: 'Jane', last_name: '' },
      { id: 'customer-03', company_name: 'Acme' }, { id: 'customer-04', company_name: '' }, ]
  end
  let(:jobs) do
    [ { id: 'job-01', title: 'Tune-up', total: 260.0, customer_id: 'customer-01',
        location_id: 'location-01', quote_id: 'quote-01', customer: { id: 'customer-01' },
        lines: [ { quantity: 3.0, name: 'Faucet install' }, { quantity: 2.5, name: 'Hours' },
                 { name: 'Trip fee', description: 'Brass', unit_price: 40.0, total: 80.0 }, ], },
      { id: 'job-02', title: '' }, { id: 'job-03' }, ]
  end
  let(:locations) do
    [ { id: 'location-01', street: '1 Main St', city: 'Raleigh', state: 'NC', zip: '27601',
        latitude: 35.77, longitude: -78.63, customer_id: 'customer-01',
        customer: { id: 'customer-01' }, },
      { id: 'location-02', city: 'Raleigh', zip: '27601' }, ]
  end

  it 'names a customer by whichever names the company holds, then by the business they are' do
    expect(company.customers.map(&:name)).to eq [ 'Jane Doe', 'Jane', 'Acme', nil ]
  end

  it 'reads a person the same way whoever they are' do
    expect(company.employees.first).to have_attributes name: 'Ada Lovelace',
      email: 'ada@example.com', phone: '5550000001', role: 'Technician'
    expect(company.leads.first).to have_attributes name: 'Ada Lovelace', source: 'Web',
      status: 'New', notes: 'Leak'
  end

  it 'names an untitled record by its ID, so a list always has something to show' do
    expect(company.jobs.map(&:name)).to eq %w[Tune-up job-02 job-03]
    expect(company.jobs.find('job-03').summary).to eq 'job-03'
  end

  it 'sums a job up by its lines, and by its name where it has none' do
    job = company.jobs.find 'job-01'

    expect(job.lines.map(&:to_s)).to eq [ '3 Faucet install', '2.5 Hours', 'Trip fee' ]
    expect(job.summary).to eq '3 Faucet install, 2.5 Hours, and Trip fee'
    expect(job.total).to eq 260.0
    expect(job.lines.last).to have_attributes name: 'Trip fee', description: 'Brass',
      quantity: nil, unit_price: 40.0, total: 80.0
  end

  it 'writes a location on one line from whatever parts of it the company holds' do
    expect(company.locations.find('location-01')).to have_attributes(
      street: '1 Main St', city: 'Raleigh', state: 'NC', zip: '27601', latitude: 35.77,
      longitude: -78.63, customer_id: 'customer-01', to_s: '1 Main St, Raleigh, NC 27601',
    )
    expect(company.locations.find('location-02').to_s).to eq 'Raleigh, 27601'
  end

  it 'brings a record another names back beside it only where it came back with it' do
    job = company.jobs.find 'job-01'

    expect(job.customer.id).to eq 'customer-01'
    expect(job.location).to be_nil
    expect(job).to have_attributes customer_id: 'customer-01', location_id: 'location-01',
      quote_id: 'quote-01'
    expect(company.locations.find('location-01').customer.id).to eq 'customer-01'
  end

  it 'hangs the records that name one off it, narrowed by its ID' do
    job = company.jobs.find 'job-01'
    customer = company.customers.find 'customer-01'
    employee = company.employees.find 'employee-01'

    expect(job.visits.conditions).to eq job_id: 'job-01'
    expect(job.invoices.conditions).to eq job_id: 'job-01'
    expect(customer.locations.conditions).to eq customer_id: 'customer-01'
    expect(customer.jobs.conditions).to eq customer_id: 'customer-01'
    expect(customer.invoices.conditions).to eq customer_id: 'customer-01'
    expect(employee.visits.conditions).to eq employee_id: 'employee-01'
  end
end
