module Company
  # One stop of a job: when the work is scheduled to happen.
  class Visit < Resource
    # What every visit reads, by the vocabulary's names.
    def self.attributes = %i[id description starts_at ends_at all_day]

    # @return [String, nil] what the stop is, in the words of whoever booked it.
    def description = attribute :description

    # @return [Time, nil] moment the visit is booked to start.
    def starts_at = time :starts_at

    # @return [Time, nil] moment the visit is booked to end.
    def ends_at = time :ends_at

    # @return [Boolean, nil] whether the visit takes a whole day rather than an hour of it.
    def all_day? = attribute :all_day
  end
end
