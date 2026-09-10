# Company

The vocabulary two field-service platforms are read in. An account -- a set of credentials on
Jobber or Housecall Pro -- opens the business it belongs to and the records the business holds:
leads, jobs, visits, and the quote a job was won with. A gem that speaks to one platform subclasses
`Company::Account` and each kind of record; every reader is named here, once.

## How to install

To install on your system, run

    gem install company

To use inside a bundled Ruby project, add this line to the `Gemfile`:

    gem 'company', '~> 1.0'

Semantic Versioning promises that `~> major.minor` never crosses a breaking change, so the pin
takes every 1.x release and stops short of 2.0.

## What an account answers

An account is the gateway a set of credentials opens. The gem holding the credentials builds
it; the vocabulary says what it answers:

```ruby
account.business # => a Company::Business, who the credentials belong to
account.jobs     # => a Company::Collection of jobs, walked however the platform pages them
account.visits   # => a Company::Collection of visits
account.leads    # => a Company::Leads: `create` files one
```

A platform that offers no such thing raises `NotImplementedError` naming the gem and the
reader, rather than answering an empty list; one that files no leads answers leads that
refuse to file one.

A collection is `Enumerable`, walked a page at a time however the platform pages it, and
narrows to a window measured from now: `account.jobs.past(4.weeks)`,
`account.visits.upcoming(2.weeks)`, or either with no duration for as far as there is. `ids`
answers every record's ID. A gem answers `each` and `between(from, to)`; the rest is here.

A lead is filed with the same words on every platform, and a platform drops what it has no
field for:

```ruby
account.leads.create name: 'Ada', surname: 'Lovelace', phone: '5553335555',
  email: 'ada@example.com', address: { street: '1 Main St', city: 'Newark', state: 'NJ',
  zip: '07102' }, description: 'Fix the sink', notes: 'Estimate $100–$200', source: 'Website'
```

## What each record answers

A record holds the node the platform answered, and a field the platform holds nothing for
answers nil. A phone answers the same ten digits whatever punctuation the platform wrote, and
nil where none is held or none is a North American number to dial.

```ruby
business.id, business.name, business.phone # => '7044597540'
business.subsidiaries # => itself first, then every business under it, flat; a gem says which

lead.id, lead.customer              # who asked for work, and the Company::Customer filed for them
quote.id, quote.amount              # a price sent to a customer, dollars as a BigDecimal

job.id, job.quote                         # => the Company::Quote it was won with, or nil
job.description                           # what the work is called
job.notes                                 # what was written on the job for the crew
job.created_at, job.scheduled_at, job.completed_at # Times, nil where not booked or done
job.amount                                # dollars, as a BigDecimal
job.lines                                 # => Company::Line: id, name, description,
                                          #    quantity (3, not 3.0), amount
job.location                              # => Company::Location, or nil

visit.id, visit.description, visit.starts_at, visit.ends_at
visit.anytime?, visit.job                 # => the Company::Job the stop belongs to

location.id, location.street, location.city, location.zip
location.latitude, location.longitude
location.customer                   # => Company::Customer: id, name, surname, email, phone
```

## Concept map
  
┌─────────────────┬───────────────────┬───────────────────────────┬────────────────────────────────────┬──────────────────────────────────┬───────────────────────────────────┬─────────────────────────────────┐
│     Concept     │      Jobber       │       Housecall Pro       │            ServiceTitan            │              Vonigo              │             Gataware              │          ServiceMinder          │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Account /       │                   │ Company (R;               │                                    │ Franchise (R,                    │                                   │ Organization (RW via brand      │
│ company         │ Account (R)       │ franchise_info,           │ Tenant in URL; Business Units (R)  │ security/franchises; token       │ Franchisee (/franchises/{id}, R)  │ key), Brand above               │
│                 │                   │ schedule_availability W)  │                                    │ session per franchise)           │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Customer        │ Client (RW)       │ Customer (RW)             │ Customer (RW)                      │ Client (data/Clients, RW)        │ Customer (R;                      │ Contact (RW; contacts/locate,   │
│                 │                   │                           │                                    │                                  │ /franchises/{id}/customers)       │ addupdate)                      │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Location /      │ Property (RW)     │ Address (RW)              │ Location (RW; customerId, zoneId)  │ Location (data/Locations, RW)    │ — (address fields on Customer)    │ — (address on Contact)          │
│ property        │                   │                           │                                    │                                  │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Contact person  │ —                 │ —                         │ Contact = contact method (type:    │ Contact (data/Contacts, RW)      │ —                                 │ —                               │
│                 │                   │                           │ MobilePhone, value), not a person  │                                  │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│                 │                   │                           │ Lead, Booking (RW); leadCallId,    │ Lead (data/Leads, subtype of     │                                   │ Contact with Category           │
│ Lead / request  │ Request (RW)      │ Lead (RW, convert)        │ bookingId on Job                   │ Client), Case (data/Cases)       │ —                                 │ Lead/Prospect; brand-key        │
│                 │                   │                           │                                    │                                  │                                   │ addupdate distributes lead      │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Estimate /      │ Quote (RW)        │ Estimate + Options (RW)   │ Estimate (Sales API)               │ Quote (R, convert→WorkOrder)     │ —                                 │ Proposal (RW: create, details,  │
│ quote           │                   │                           │                                    │                                  │                                   │ alltemplates)                   │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│                 │                   │                           │ Job (RW; jobTypeId,                │ WorkOrder (data/WorkOrders, RW;  │ Appointment (job and visit are    │ Appointment-centric; "Job" only │
│ Job             │ Job (RW)          │ Job (RW)                  │ businessUnitId, appointmentCount)  │ status strings like "Service     │ one object)                       │  in marketing copy              │
│                 │                   │                           │                                    │ Complete")                       │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Visit /         │                   │                           │ Appointment (RW; start, end,       │ schedule + Route on WorkOrder;   │ Appointment (R, PATCH; date_time, │ Appointment (find, update,      │
│ appointment     │ Visit (RW)        │ Job Appointment (RW)      │ arrivalWindowStart/End);           │ Jobs object exists (?)           │  duration, team)                  │ book, cancel, addtip)           │
│                 │                   │                           │ Appointment Assignment (dispatch)  │                                  │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Invoice         │ Invoice (RW)      │ Invoice (R)               │ Invoice (R; subTotal, total,       │ Invoice (R,                      │ — (totals live on Appointment)    │ Invoice (get, query, import)    │
│                 │                   │                           │ balance)                           │ WorkOrdersAddInvoice)            │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Payment         │ Payment (R)       │ — in spec; webhook events │ Payment (R + POST with             │ Payment (R)                      │ —                                 │ Payment (query, import)         │
│                 │                   │  only                     │ splits[{invoiceId, amount}])       │                                  │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│                 │                   │                           │                                    │                                  │ AppointmentService                │                                 │
│ Line item       │ LineItem (RW)     │ Line Item (RW)            │ Invoice items[] (R/W)              │ Charge (data/Charges, R)         │ (/appointment-services,           │ ProposalLine / AddOnParts       │
│                 │                   │                           │                                    │                                  │ POST/DELETE)                      │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Employee / user │ User (R)          │ Employee (R)              │ Technician, Employee; technician   │ Route (resources/Routes, R) is   │ phcs[] + team embedded on         │ User (user/all, create),        │
│                 │                   │                           │ rating (PUT)                       │ the dispatchable "groomer"       │ Appointment                       │ ServiceAgent                    │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Catalog         │ ProductOrService  │ Job Types, Materials      │ Pricebook (RW)                     │ ServiceType, PriceItem           │ Franchise Service / add-on        │ Service (services/all), Part    │
│                 │ (RW)              │                           │                                    │ (data/priceLists)                │ (/franchise-services)             │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Tag / note /    │ Tag, Note,        │                           │                                    │ Fields are all custom            │                                   │                                 │
│ custom field    │ CustomField (RW)  │ Tag, Note, Attachment     │ tagTypeIds, customFields[], notes  │ (system/objects metadata); Note  │ —                                 │ Tags, Notes, CustomFields (RW)  │
│                 │                   │                           │                                    │ (W)                              │                                   │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Webhook / event │ Webhook topics    │ Webhook subscription +    │ Webhooks API                       │ — (poll by dateMode              │ — (poll search=updated|gt|…;      │ NotificationUri callback;       │
│                 │ (RW)              │ Events                    │                                    │ edited/created)                  │ /deleted-appointments)            │ DataSubscriber fetch/clear poll │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│                 │                   │ Booking Windows, Schedule │ Dispatch capacity (POST), arrival  │ Availability                     │ /appointments/availability →      │                                 │
│ Availability    │ —                 │  Availability             │ windows                            │ (resources/availability), Lock   │ Morning/Midday/Afternoon blocks   │ appointments/slotsearch         │
│                 │                   │                           │                                    │                                  │ per team                          │                                 │
├─────────────────┼───────────────────┼───────────────────────────┼────────────────────────────────────┼──────────────────────────────────┼───────────────────────────────────┼─────────────────────────────────┤
│ Franchise /     │ —                 │ X-Company-Id, franchise   │ Tenant + Business Units            │ Franchise session per token      │ franchisee_id on every call, one  │ Brand → Organizations;          │
│ multi-location  │                   │ metadata                  │                                    │                                  │ key per env                       │ org/brand/data keys             │
└─────────────────┴───────────────────┴───────────────────────────┴────────────────────────────────────┴──────────────────────────────────┴───────────────────────────────────┴─────────────────────────────────┘

Gataware: Two Maids' in-house platform (trademark of Two Maids Franchising, LLC), Django-style REST at https://gataware.com/api/ (new) and /rest-api/ (old), X-Api-Key header; Swagger at testing.gataware.com/swagger/
(private). Not a market vendor, but a real API with franchisee, customer, appointment, availability and add-on resources.


## Answering as a gem

The least a gem writes is under `test/acme`: an account over a few records of its own, with
`each` and `between` on its collections, `create` on its leads, and one `keys` map. The test
that runs every reader through it, `test/company/acme_test.rb`, reads as a tutorial.


A gem subclasses `Company::Account` and answers the readers its platform offers, holding its
own credentials however the platform hands them out:

```ruby
class Jobber::Account < Company::Account
  def business = Company::Business.new node: query(BUSINESS)
  def jobs = Jobber::Jobs.new account: self
end
```

A record is read by subclassing each kind -- `class Housecall::Business < Company::Business`
-- and naming under `keys` the node keys the platform spells otherwise than the vocabulary. A
reader left out reads the key of its own name, so a gem whose platform writes `name` inherits
`name` outright, and a reader whose value needs more than a rename is declared outright:

```ruby
class Housecall::Business < Company::Business
  # What Housecall Pro spells otherwise than the vocabulary.
  def self.keys = { phone: :phone_number }
end

Housecall::Business.node_keys # => [:id, :name, :phone_number], what to ask the platform for
```

## Errors

Every error a platform gem raises descends from `Company::Error`, so one rescue catches the
lot, and one held to a rate from `Company::Throttled`, so one retry covers every platform.

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
