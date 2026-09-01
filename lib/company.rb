require 'bigdecimal'

require 'company/version'

# The whole of it: a name a platform holds nothing for arrives as readily empty as null, and
# a platform's keys are read in whichever case it spells them.
require 'active_support'
require 'active_support/core_ext'

require 'company/error'
require 'company/phone'
require 'company/resource'
require 'company/resources/account'
require 'company/resources/customer'
require 'company/resources/location'
require 'company/resources/line'
require 'company/resources/visit'
require 'company/resources/job'

# After every resource, which is what it hands back.
require 'company/mock'

# The business behind a set of credentials on a field-service platform, and every record it
# holds. Included the way Enumerable is: a class answering {#read} gets the account. The
# vocabulary grows a kind at a time, and the account is the first.
#
# An includer answers two methods, neither defined here:
#
#     read(type, id = nil)  # => the Resource filed under that ID, or nil; the account with none
#     jobs                  # => an Enumerable of every Job, paged however the platform pages
module Company
  # The one business the credentials belong to: there is no list of them and no ID to find it
  # by, so it is read without one.
  # @return [Account] account the credentials belong to.
  def account = read Account

  # @param id [String] ID the company files the job under.
  # @return [Job, nil] job filed under that ID, or nil where the company has none.
  def job(id) = read Job, id
end
