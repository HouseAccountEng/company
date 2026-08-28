# The mock reads from what a test handed it, and everything else -- narrowing, walking, the
# readers on each record -- is the code a real company runs.
RSpec.describe Company::Mock do
  let(:company) do
    described_class.new account: { id: 'account-01', name: 'Acme Plumbing' },
      customers: [ { id: 'customer-01', first_name: 'Jane', last_name: 'Doe' } ],
      jobs: [
        { id: 'job-01', title: 'Tune-up', scheduled_at: 1.day.ago, customer_id: 'customer-01' },
        { id: 'job-02', scheduled_at: 3.months.ago, customer_id: 'customer-01' },
        { id: 'job-03', scheduled_at: 2.days.from_now, customer_id: 'customer-02' },
      ]
  end

  it 'answers the account without an ID' do
    expect(company.account).to have_attributes id: 'account-01', name: 'Acme Plumbing'
  end

  it 'answers every record of a kind, in the order it was handed them' do
    expect(company.jobs.map(&:id)).to eq %w[job-01 job-02 job-03]
    expect(company.jobs.first).to be_a Company::Job
  end

  it 'dates nothing itself: a half of the schedule is whatever the test dated each record' do
    expect(company.jobs.past.ids).to eq %w[job-01 job-02]
    expect(company.jobs.upcoming.ids).to eq %w[job-03]
  end

  it 'measures a window from now' do
    expect(company.jobs.past(2.months).ids).to eq %w[job-01]
    expect(company.jobs.upcoming(1.day).ids).to be_empty
  end

  it 'matches a condition by equality, and a range by cover' do
    expect(company.jobs.where(customer_id: 'customer-01').ids).to eq %w[job-01 job-02]
    expect(company.jobs.where(scheduled_at: 1.week.ago..).ids).to eq %w[job-01 job-03]
  end

  it 'orders, and cuts' do
    expect(company.jobs.order(scheduled_at: :asc).ids).to eq %w[job-02 job-01 job-03]
    expect(company.jobs.order(scheduled_at: :desc).limit(2).ids).to eq %w[job-03 job-01]
  end

  it 'finds a record by its ID, and nothing by an ID it was not handed' do
    expect(company.jobs.find('job-01').title).to eq 'Tune-up'
    expect(company.jobs.find('job-99')).to be_nil
  end

  it 'walks lazily, building a record only as far as the walk goes' do
    expect(company.walk(company.jobs)).to be_a Enumerator::Lazy
    expect(company.jobs.first.id).to eq 'job-01'
  end

  it 'hangs every list off the record it belongs to' do
    expect(company.customers.find('customer-01').jobs.ids).to eq %w[job-01 job-02]
  end

  it 'holds nothing of a kind it was not handed' do
    expect(company.visits.to_a).to be_empty
    expect(company.leads.find('lead-01')).to be_nil
  end
end
