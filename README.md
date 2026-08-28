# Company

The records a field-service business holds -- its customers, jobs, visits, invoices -- in one
vocabulary, whichever platform holds them. A gem that speaks to one platform includes `Company`
and answers two methods; every list, every window on it and every reader on a record is here.

## How to install

To install on your system, run

    gem install company

To use inside a bundled Ruby project, add this line to the `Gemfile`:

    gem 'company', '~> 0.1.0'

Below 1.0 the pin names the patch as well as the minor, so `bundle update` stops short of
`0.2.0`. Semantic Versioning lets a `0.x` release break whatever it likes, and only promises
otherwise once the major is real -- at which point the pin loosens to `~> 1.0`.

## What a company answers

A company is the business behind a set of credentials. Whatever class holds those credentials
includes `Company` and gets the account and one list per kind of record:

```ruby
company.account # => the business itself: name, phone, email, website, time_zone, location
company.customers # => an Enumerable of every customer, nothing fetched yet
company.locations, company.leads, company.quotes, company.jobs, company.visits
company.invoices, company.payments, company.employees, company.availability
```

### Lists

Every list is a `Company::Relation`: chain it the way Active Record does, and nothing is read
until the walk starts. A page is read only once the one before it runs out, so `first` costs
one request where `to_a` costs as many as the business has pages.

```ruby
company.jobs.where status: 'archived'
company.jobs.where(customer_id: id).order(scheduled_at: :desc).limit 10
company.jobs.includes :customer, location: :customer # brought back beside each job
company.jobs.find id # => the job filed under that ID, or nil
company.jobs.past.ids # => %w[job-01 ...], every page of them, and nothing else about them
```

Either half of a schedule takes how much of it you meant -- a duration, measured from the same
now the half is split at -- and a walk that stops at a boundary reads only the pages up to it:

```ruby
company.jobs.past # => the ones booked before now
company.jobs.upcoming # => the ones booked from now on
company.jobs.past(2.months) # => only as far back as two months, which is fewer pages
company.visits.upcoming(1.week).ids
```

Each kind is dated by its own moment: a job by `scheduled_at`, a visit by `starts_at`, an
invoice by `issued_at`, a payment by `paid_at`, a window by `starts_at`, and everything else by
`created_at`. A condition written as a range does the same by hand:

```ruby
company.invoices.where issued_at: 1.year.ago..Time.now
```

### Records

```ruby
job = company.jobs.first
job.name # => 'Furnace tune-up', or the job's ID where nobody titled it
job.title, job.instructions, job.status, job.total
job.scheduled_at, job.completed_at, job.created_at, job.updated_at
job.customer_id, job.location_id, job.quote_id
job.summary # => '3 Faucet install and 2 Valve change': the lines as a sentence, or the name
job.lines # => an Array of Company::Line, each answering quantity, name, unit_price, total
job.visits, job.invoices # => Relations narrowed to this job

customer = company.customers.find id
customer.name # => 'Jane Doe', or the business's name where the customer is one
customer.first_name, customer.last_name, customer.company_name, customer.email, customer.phone
customer.locations, customer.jobs, customer.invoices

visit.job_id, visit.starts_at, visit.ends_at, visit.all_day?, visit.confirmed?, visit.employees
invoice.number, invoice.status, invoice.total, invoice.balance, invoice.issued_at, invoice.due_at
payment.invoice_id, payment.amount, payment.method, payment.paid_at
quote.lead_id, quote.status, quote.total, quote.sent_at, quote.lines, quote.jobs
lead.name, lead.phone, lead.email, lead.source, lead.status, lead.notes, lead.location
location.street, location.city, location.state, location.zip, location.latitude, location.longitude
location.to_s # => '1 Main St, Raleigh, NC 27601'
employee.name, employee.email, employee.phone, employee.role, employee.visits
window.starts_at, window.ends_at, window.available?, window.employees
```

Nothing nested comes back unasked. `job.customer` is the customer where the list was asked to
`includes` it, and nil otherwise -- `job.customer_id` is always there to `find` one by. Every
moment reads as a `Time`, however the platform wrote it, and a record is only ever reached
through its company: nothing here is built by hand.

## Answering as a company

`Company` is included the way `Enumerable` is. Where `Enumerable` asks for `each`, `Company`
asks for two methods, and builds everything above on them:

```ruby
class Jobber
  include Company

  # Every record the relation names, as this gem's records, a page read only as it is walked.
  def walk(relation)
    relation.type # => Company::Job
    relation.conditions # => { scheduled_at: 2.months.ago..Time.now, status: 'archived' }
    relation.sorts, relation.cap, relation.inclusions
    Enumerator.new { |yielder| ... yielder << Job.new(node: node, company: self) }
  end

  # The record filed under an ID, or nil. The account is asked for with no ID at all.
  def read(type, id = nil) = ...

  # How the platform spells its keys.
  def keys = :camel
end
```

A record holds the node the platform answered, as it came, and a gem reads it by subclassing
each kind -- `class Jobber::Job < Company::Job` -- declaring the readers whose key is spelled
differently or whose value is not what the vocabulary promises. `keys` says how much of that
is needed:

```ruby
def keys = :snake # first_name reads first_name: only a differently named key is declared
def keys = :camel # first_name reads firstName, created_at reads createdAt, and so on
def keys = nil    # the default: the gem declares every reader, and an undeclared one raises
```

So a gem whose platform writes `first_name` inherits `first_name` outright, and one whose
customer carries `mobile_number`, `home_number` and `work_number` declares `phone` alone:

```ruby
class Housecall::Customer < Company::Customer
  def phone = @node['mobile_number'] || @node['home_number'] || @node['work_number']
end
```

`ids(relation)` walks the list by default; an includer whose platform prices a page of IDs below
a page of records overrides it.

Everything an includer raises descends from `Company::Error`: `Company::Refused` where the
platform will not take the credentials themselves, and `Company::Retriable` where it held the
request to a rate and the question is worth asking again.

## Mocking a company

`Company::Mock` is a company answering from what a test hands it, and the one includer this gem
ships. Only the reading is mocked: narrowing, walking and every reader run the real code.

```ruby
company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing' },
  customers: [ { id: 'customer-01', first_name: 'Jane', last_name: 'Doe' } ],
  jobs: [ { id: 'job-01', title: 'Tune-up', scheduled_at: 1.day.ago, customer_id: 'customer-01',
            lines: [ { quantity: 3.0, name: 'Faucet install' } ] } ]

company.jobs.past(2.months).ids # => %w[job-01]
company.jobs.find('job-01').summary # => '3 Faucet install'
company.customers.find('customer-01').jobs.count # => 1
```

The mock dates nothing it was handed: what answers to `past` and `upcoming` is whatever
`scheduled_at` the test gave each job. A condition matches by `===`, so a range covers and
anything else has to equal.

## Development

`bin/setup` gets a clone working, `bin/console` opens a prompt with the library loaded, and
`bundle exec rake` runs the suite, the linter and the two size limits -- which is what CI runs
too.

## Reference

The API reference is built from what RubyGems holds, at
[rubydoc.info/gems/company](https://rubydoc.info/gems/company). The source is at
[github.com/claudiob/company](https://github.com/claudiob/company).

## License

MIT, see [LICENSE.txt](LICENSE.txt).
