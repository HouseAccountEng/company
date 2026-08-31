require 'company/version'

# The whole of it: a name a platform holds nothing for arrives as readily empty as null, and
# a platform's keys are read in whichever case it spells them.
require 'active_support'
require 'active_support/core_ext'

require 'company/resource'
require 'company/resources/account'

# After every resource, which is what it hands back.
require 'company/mock'

# The business behind a set of credentials on a field-service platform, and every record it
# holds. Included the way Enumerable is: a class answering {#read} gets the account, and may
# say how its platform spells its keys -- see {#keys}. The vocabulary grows a kind at a time,
# and the account is the first.
#
# An includer answers one method, not defined here:
#
#     read(type, id = nil)  # => the Resource filed under that ID, or nil; the account with none
module Company
  # The one business the credentials belong to: there is no list of them and no ID to find it
  # by, so it is read without one.
  # @return [Account] the account.
  def account = read Account

  # How the platform spells its keys. :snake or :camel lets a reader whose name matches its key
  # go undeclared in a subclass, `time_zone` reading `time_zone` or `timeZone`; nil, the
  # default, says the gem declares every reader itself, and an undeclared one raises.
  # @return [Symbol, nil] :snake, :camel, or nil.
  def keys = nil
end
