# Company

The vocabulary two field-service platforms are read in. An account -- a set of credentials on
Jobber or Housecall Pro -- opens the business it belongs to and the records the business holds:
leads, quotes, jobs, visits, invoices. A gem that speaks to one platform subclasses
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
account.leads    # => the business's leads: `create` files one
account.quotes   # => the business's quotes: `find` reads one by ID
account.jobs     # => the business's jobs: `find` reads one by ID
account.visits   # => the business's visits: `find` reads one by ID
account.invoices # => the business's invoices: `find` reads one by ID
```

A platform that offers no such thing raises `NotImplementedError` naming the gem and the
reader, rather than answering an empty list.

## What each record answers

A record holds the node the platform answered, and a field the platform holds nothing for
answers nil. A phone answers the same ten digits whatever punctuation the platform wrote, and
nil where none is held or none is a North American number to dial.

```ruby
business.id, business.name, business.phone # => '7044597540'
business.subsidiaries # => itself first, then every business under it, flat; a gem says which

lead.id, lead.customer_id           # who asked for work, and the customer filed for them
quote.id, quote.lead_id             # a price sent to answer a lead

job.id, job.quote_id, job.quote_amount    # what the job was won with, dollars as a BigDecimal
job.instructions                          # what the crew was asked to mind
job.summary                               # => '3 Faucet install and Trip fee', or the
                                          #    description, or the ID -- never blank
job.created_at, job.scheduled_at, job.completed_at # Times, nil where not booked or done
job.amount                                # dollars, as a BigDecimal
job.lines                                 # => Company::Line: id, name, description,
                                          #    quantity (3, not 3.0), amount, to_s
job.location                              # => Company::Location, or nil

visit.id, visit.description, visit.starts_at, visit.ends_at
visit.all_day?, visit.confirmed?, visit.location

invoice.id, invoice.job_id, invoice.amount
invoice.fulfilled_at                # when the billed work was finished, or the bill issued

location.id, location.street, location.city, location.zip
location.latitude, location.longitude
location.customer                   # => Company::Customer: id, name, last_name, email, phone
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
