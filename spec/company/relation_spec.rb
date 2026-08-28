# A relation is what a caller narrows, orders and cuts before a single record is read. The
# company walking it is handed the whole of that, and nothing is read until the walk starts.
RSpec.describe Company::Relation do
  let(:company) { instance_double Company::Mock }
  let(:jobs) { described_class.new type: Company::Job, company: company }

  it 'reads nothing until it is walked' do
    expect(company).not_to receive :walk

    jobs.where(status: 'archived').order(scheduled_at: :desc).limit(3).includes(:customer)
  end

  it 'hands the company what it was narrowed, ordered, cut and asked to bring back' do
    narrowed = jobs.where(status: 'archived').where(customer_id: 'customer-01').
      order(scheduled_at: :desc).limit(3).includes(:customer, location: :customer)

    expect(narrowed).to have_attributes type: Company::Job,
      conditions: { status: 'archived', customer_id: 'customer-01' },
      sorts: { scheduled_at: :desc }, cap: 3, inclusions: [ :customer, { location: :customer } ]
  end

  it 'leaves the list it was chained off as it was' do
    jobs.where status: 'archived'

    expect(jobs.conditions).to be_empty
  end

  it 'walks whatever the company answers, one record at a time' do
    job = Company::Job.new attributes: { id: 'job-01' }
    allow(company).to receive(:walk).with(jobs).and_return [ job ].each

    expect(jobs.first).to be job
    expect(jobs.each).to be_an Enumerator
  end

  it 'finds a record by the ID the company files it under, not by walking' do
    job = Company::Job.new attributes: { id: 'job-01' }
    allow(company).to receive(:read).with(Company::Job, 'job-01').and_return job

    expect(jobs.find('job-01')).to be job
  end

  it 'asks the company for the IDs alone' do
    allow(company).to receive(:ids).with(jobs).and_return %w[job-01]

    expect(jobs.ids).to eq %w[job-01]
  end

  describe 'a half of the schedule' do
    it 'is split at the moment it is asked for, and open at its far end' do
      past, upcoming = jobs.past.conditions[:scheduled_at], jobs.upcoming.conditions[:scheduled_at]

      expect(past).to have_attributes begin: nil, end: (be_within 1).of(Time.now)
      expect(upcoming).to have_attributes begin: (be_within 1).of(Time.now), end: nil
    end

    it 'is measured from that same moment where a caller says how much of it they meant' do
      window = jobs.past(2.months).conditions[:scheduled_at]

      expect(window.begin).to be_within(1).of 2.months.ago
      expect(window.end).to be_within(1).of Time.now
    end

    it 'runs ahead as far as the caller asked' do
      window = jobs.upcoming(1.week).conditions[:scheduled_at]

      expect(window.begin).to be_within(1).of Time.now
      expect(window.end).to be_within(1).of 1.week.from_now
    end

    it 'narrows each kind of record by its own moment' do
      expect(Company::Visit.all(company).past.conditions).to include :starts_at
      expect(Company::Invoice.all(company).past.conditions).to include :issued_at
      expect(Company::Payment.all(company).past.conditions).to include :paid_at
      expect(Company::Availability.all(company).upcoming.conditions).to include :starts_at
      expect(Company::Quote.all(company).past.conditions).to include :created_at
    end
  end
end
