# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check [Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## [Unreleased]

* [Feature] `Company`, included the way `Enumerable` is: a class answering `read` gets
  `account`, and says with `keys` how its platform spells them -- :snake, :camel, or nil for a
  gem that declares every reader itself
* [Feature] `Company::Account` -- id, name, phone, email, website, time_zone -- and
  `Company::Mock`, a company answering from what a test hands it

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
