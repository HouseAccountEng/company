module Company
  # Somebody who does the work.
  class Employee < Resource
    include Person

    # @return [String, nil] what the business calls their job.
    def role = attribute :role

    # @return [Relation] the stops they are assigned to.
    def visits = @company.visits.where employee_id: id
  end
end
