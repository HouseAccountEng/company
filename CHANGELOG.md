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

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
