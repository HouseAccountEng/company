# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check [Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## [Unreleased]

* [Feature] `Company`, included the way `Enumerable` is: a class answering `walk` and `read`
  gets `account`, `customers`, `locations`, `leads`, `quotes`, `jobs`, `visits`, `invoices`,
  `payments`, `employees` and `availability`
* [Feature] `Company::Relation`, the list every one of those answers: `where`, `order`, `limit`,
  `includes`, `past`, `upcoming`, `find` and `ids`, none of it read until walked
* [Feature] A record for each kind, with the lists that hang off it, and `Company::Mock`, a
  company answering from what a test hands it

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
