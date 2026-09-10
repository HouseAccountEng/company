module Acme
  # A business with a branch, spelling its phone the way a platform might.
  class Business < Company::Business
    # The node a platform would answer for the account, its branch nested under it.
    NODE = { id: 'acme', name: 'Acme Plumbing', phone_number: '(704) 459-7540',
             branches: [ { id: 'acme-north', name: 'Acme Plumbing North',
                           phone_number: '(704) 459-7541', branches: [], } ], }

    def self.keys = { phone: :phone_number }

  private

    def below = records Business, :branches
  end
end
