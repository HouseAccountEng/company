module Company
  # Work the business accepted and scheduled.
  class Job < Resource
    # What every job reads, by the vocabulary's names.
    def self.attributes = %i[id description created_at scheduled_at completed_at amount]

    # @return [String, nil] what the work is, in the words of whoever opened the job.
    def description = attribute :description

    # @return [Time] moment the job was opened.
    def created_at = time :created_at

    # @return [Time, nil] moment the work is booked for.
    def scheduled_at = time :scheduled_at

    # @return [Time, nil] moment the work was finished.
    def completed_at = time :completed_at

    # @return [BigDecimal, nil] what the job comes to, in dollars.
    def amount = decimal :amount

    # @return [Enumerable<Line>] lines the work is billed as, empty where none came back.
    def lines = records Line, :lines

    # @return [Enumerable<Visit>] stops the work is booked as, empty where none came back.
    def visits = records Visit, :visits
  end
end
