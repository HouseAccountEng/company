# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check [Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 1.0.0 - 2026-09-09

* [Feature] `Company::Account`, the gateway a set of credentials opens: a gem subclasses it
  and answers `business`, `leads`, `quotes`, `jobs`, `visits` and `invoices` as its platform
  offers them; a reader left out raises `NotImplementedError` naming the gem and the reader
* [Feature] `Company::Business` -- id, name, phone, subsidiaries -- who the credentials belong to.
  The subsidiaries are the business itself and then every business under it at any depth,
  flat, so the list is never empty; a gem whose platform nests them answers the ones directly
  under it from the private `below`
* [Feature] `Company::Lead` -- id, customer_id -- and `Company::Quote` -- id, lead_id, amount
* [Feature] `Company::Job` -- id, quote, instructions, summary, created_at, scheduled_at,
  completed_at, amount, lines, location. The summary is the lines as a sentence,
  or the description, or the ID, and is never blank; the moments answer as Times however the
  platform wrote them and the amounts as dollars in a BigDecimal
* [Feature] `Company::Line` -- id, name, description, quantity, amount -- a whole quantity read
  whole, and `to_s` answering how many of what: `3 Bathroom Faucet Installation`
* [Feature] `Company::Visit` -- id, description, starts_at, ends_at, all_day?, confirmed?,
  location
* [Feature] `Company::Invoice` -- id, job_id, amount, and fulfilled_at: when the billed work
  was finished, or the bill issued where the work is undated
* [Feature] `Company::Location` -- id, street, city, zip, latitude, longitude, customer -- and
  `Company::Customer` -- id, name, last_name, email, phone
* [Feature] A record reads the node its platform answered under either kind of key; a kind
  names its attributes, a subclass names under `.keys` the node keys its platform spells
  otherwise -- `{ phone: :phone_number }` -- and `node_keys` answers them through the map, so
  a gem builds its query from what the vocabulary reads
* [Feature] A phone answers as the ten digits a North American number is, however the platform
  wrote it, and as nil where none is held or none can be dialed
* [Feature] `Company::Error`, what every error a platform gem raises descends from

The draft that had `Company` included the way `Enumerable` is, answering `read`, with an
`Account` record and a `Company::Mock`, never shipped.

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
