# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check [Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## [Unreleased]

* [Feature] `Company`, included the way `Enumerable` is: a class answering `read` gets
  `account`
* [Feature] `Company::Account` -- id, name, phone -- and `Company::Mock`, a company answering
  from what a test hands it. A subclass names under `.keys` the node keys its platform spells
  otherwise -- `{ phone: :phone_number }` -- and a reader left out reads the key of its own
  name
* [Feature] A phone answers as the ten digits a North American number is, however the
  platform wrote it; one that is not raises `Company::Error` rather than answering nil
* [Feature] A kind names its attributes, and `node_keys` answers them through the `.keys`
  map, so a gem builds its query from what the vocabulary reads and writes no key by hand
* [Feature] `Company::Job` -- id, description, created_at, scheduled_at, completed_at,
  amount -- read as `company.job id`; the three moments answer as Times however the platform
  wrote them, the amount as dollars in a BigDecimal, and only the id and created_at are
  never nil
* [Feature] `Company::Line` -- id, name, description, quantity, amount -- the lines a job is
  billed as, a whole quantity read whole and the amount in dollars as a BigDecimal
* [Feature] `account.jobs`, every job the business holds: the gem including `Company` says
  how they are queried and how their pages follow one another, and the account walks them

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
