module Company
  # One stop at a location: when the work on a job is scheduled to happen.
  class Visit < Resource
    include Named

    # A visit's half of the schedule is the one it starts on.
    def self.window = :starts_at

    # @return [String, nil] the ID of the job the visit belongs to.
    def job_id = attribute :job_id

    # @return [Time, nil] when the visit starts.
    def starts_at = time :starts_at

    # @return [Time, nil] when the visit ends.
    def ends_at = time :ends_at

    # @return [Boolean, nil] whether the visit takes the whole day rather than an hour of it.
    def all_day? = attribute :all_day

    # @return [Boolean, nil] whether the customer has confirmed the visit.
    def confirmed? = attribute :confirmed

    # @return [Job, nil] the work the visit is a stop of, where it came back with the visit.
    def job = record Job, :job

    # @return [Array<Employee>] who is assigned to the visit, where they came back with it.
    def employees = records Employee, :employees
  end
end
