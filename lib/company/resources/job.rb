module Company
  # Work the business accepted and scheduled.
  class Job < Resource
    include Itemized, Named, Timestamped

    # A job's half of the schedule is the one it is booked on.
    def self.window = :scheduled_at

    # @return [String, nil] the ID of the customer the work is for.
    def customer_id = attribute :customer_id

    # @return [String, nil] the ID of the location the work happens at.
    def location_id = attribute :location_id

    # @return [String, nil] the ID of the quote the job was won with.
    def quote_id = attribute :quote_id

    # @return [String, nil] what the work is, in the words whoever opened the job wrote.
    def instructions = attribute :instructions

    # @return [String, nil] where the business files the job in its own workflow.
    def status = attribute :status

    # @return [Time, nil] when the work is booked for.
    def scheduled_at = time :scheduled_at

    # @return [Time, nil] when the work was finished.
    def completed_at = time :completed_at

    # The lines say what the work was where a title only says what it was called, so they read
    # better than one, and {Named#name} stands in where the job has no lines.
    # @return [String, nil] the lines as a sentence, `3 Faucet install and 2 Valve change`, or
    #   the title, or the ID.
    def summary = lines.to_sentence.presence || name

    # @return [Customer, nil] who the work is for, where they came back with the job.
    def customer = record Customer, :customer

    # @return [Location, nil] where the work happens, where it came back with the job.
    def location = record Location, :location

    # @return [Relation] the stops the work is made of.
    def visits = @company.visits.where job_id: id

    # @return [Relation] the bills issued for the work.
    def invoices = @company.invoices.where job_id: id
  end
end
