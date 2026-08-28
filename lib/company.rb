require 'company/version'

# The whole of it: a name a platform holds nothing for arrives as readily empty as null, a
# window is measured in the durations a caller writes, and a job's lines read as a sentence.
require 'active_support'
require 'active_support/core_ext'

require 'company/error'
require 'company/errors/refused'
require 'company/errors/retriable'

# Relation before Resource, whose lists are relations, and every concern before the records
# including it.
require 'company/relation'
require 'company/resource'
require 'company/concerns/named'
require 'company/concerns/person'
require 'company/concerns/timestamped'
require 'company/concerns/itemized'

# Line before the records made of lines, and Employee before the visits it is assigned to.
require 'company/resources/line'
require 'company/resources/employee'
require 'company/resources/account'
require 'company/resources/location'
require 'company/resources/customer'
require 'company/resources/lead'
require 'company/resources/quote'
require 'company/resources/job'
require 'company/resources/visit'
require 'company/resources/invoice'
require 'company/resources/payment'
require 'company/resources/availability'

# After every resource, which is what it hands back.
require 'company/mock'

# The business behind a set of credentials on a field-service platform, and every record it
# holds. Included the way Enumerable is: a class answering {#walk} and {#read} gets the account
# and every list below, each narrowed, ordered and cut before a single record is read.
#
# An includer answers two methods, neither defined here, and may say how its platform spells
# its keys, so that a reader whose name matches one goes undeclared -- see {#keys}:
#
#     walk(relation)  # => an Enumerable of every Resource the relation names, a page at a time
#     read(type, id)  # => the Resource filed under that ID, or nil; the account with no ID
module Company
  # The one business the credentials belong to: there is no list of them and no ID to find it
  # by, so it is read without one.
  # @return [Account] the account.
  def account = read Account

  # @return [Relation] the people the business works for.
  def customers = Customer.all self

  # @return [Relation] the places the work happens at.
  def locations = Location.all self

  # @return [Relation] the people who asked for work and are not customers yet.
  def leads = Lead.all self

  # @return [Relation] the prices sent to customers.
  def quotes = Quote.all self

  # @return [Relation] the work accepted and scheduled.
  def jobs = Job.all self

  # @return [Relation] the stops at a location a job is made of.
  def visits = Visit.all self

  # @return [Relation] the bills issued for finished work.
  def invoices = Invoice.all self

  # @return [Relation] the money taken against invoices.
  def payments = Payment.all self

  # @return [Relation] the people who do the work.
  def employees = Employee.all self

  # @return [Relation] when the business is free to be booked.
  def availability = Availability.all self

  # The IDs a list holds and nothing else about it. Answered by walking the list, which an
  # includer overrides where its platform prices a page of IDs below a page of records.
  # @param relation [Relation] the list, narrowed as the caller left it.
  # @return [Array<String>] every ID in the list.
  def ids(relation) = walk(relation).map(&:id).to_a

  # How the platform spells its keys. :snake or :camel lets a reader whose name matches its key
  # go undeclared in a subclass, `first_name` reading `first_name` or `firstName`; nil, the
  # default, says the gem declares every reader itself, and an undeclared one raises.
  # @return [Symbol, nil] :snake, :camel, or nil.
  def keys = nil
end
