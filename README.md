# Company

The records a field-service business holds -- its customers, jobs, visits, invoices -- in one
vocabulary, whichever platform holds them. A gem that speaks to one platform includes `Company`
and answers one method; every reader on a record is here.

The vocabulary grows a kind at a time, and the account is the first: job, line, visit,
location and customer follow, and the full shape -- relations, windows, twelve kinds -- waits
on the `resources` branch until each takes its turn.

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
includes `Company` and gets the account: there is no list of them and no ID to find one by, so
it is read without one.

```ruby
company.account.id # => 'account-01'
company.account.name # => 'Acme Plumbing'
company.account.phone # => '4562232934', ten digits however the platform wrote them
```

A job is read by the ID the company files it under:

```ruby
job = company.job 'job-01'
job.description # => 'Furnace tune-up'
job.created_at # => 2026-08-09 14:00:00 UTC, a Time however the platform wrote it
job.scheduled_at, job.completed_at # => Times too, nil where nothing is booked or done yet
job.amount # => 260.0, dollars, as a BigDecimal
```

A record is only ever reached through its company: nothing here is built by hand, and a field
the platform holds nothing for answers nil. A phone is the exception worth naming: it answers
the same ten digits whatever punctuation the platform wrote, nil where none is held, and a
number that is not a North American one raises `Company::Error` rather than answering nil.

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


## Answering as a company

`Company` is included the way `Enumerable` is. Where `Enumerable` asks for `each`, `Company`
asks for `read`, and builds everything above on it:

```ruby
class Jobber
  include Company

  # The record filed under an ID, or nil. The account is asked for with no ID at all.
  def read(type, id = nil) = ...
end
```

A record holds the node the platform answered, as it came -- either kind of key reads -- and
a gem reads it by subclassing each kind -- `class Jobber::Account < Company::Account` --
naming under `keys` the node keys its platform spells otherwise than the vocabulary. A reader left out reads the key of its own
name, so a gem whose platform writes `name` inherits `name` outright:

```ruby
class Housecall::Account < Company::Account
  # What Housecall Pro spells otherwise than the vocabulary.
  def self.keys = { phone: :phone_number }
end
```

A reader whose value needs more than a rename is declared outright, and a platform that
answers lazily overrides the private `node` instead, with every inherited reader waiting on
it.

## Mocking a company

`Company::Mock` is a company answering from what a test hands it, and the one includer this
gem ships. Only the reading is mocked: every reader on a record runs the real code.

```ruby
company = Company::Mock.new account: { id: 'account-01', name: 'Acme Plumbing' }
company.account.name # => 'Acme Plumbing'
company.account.phone # => nil
```

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
