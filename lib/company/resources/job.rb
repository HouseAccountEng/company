module Company
  # Work the business accepted and scheduled.
  class Job < Resource
    # What every job reads, by the vocabulary's names.
    def self.attributes
      %i[id description instructions created_at scheduled_at completed_at amount]
    end

    # @return [String, nil] what the work is called, in the words of whoever opened the job.
    def description = attribute :description

    # @return [String, nil] what whoever opened the job asked the crew to mind.
    def instructions = attribute :instructions

    # @return [Time] moment the job was opened.
    def created_at = time :created_at

    # @return [Time, nil] moment the work is booked for.
    def scheduled_at = time :scheduled_at

    # @return [Time, nil] moment the work was finished.
    def completed_at = time :completed_at

    # @return [BigDecimal, nil] what the job comes to, in dollars.
    def amount = decimal :amount

    # @return [Quote, nil] quote the job was won with, where it came back beside the job.
    def quote = record Quote, :quote

    # @return [Array<Line>] lines the work is billed as, empty where none came back.
    def lines = records Line, :lines

    # @return [Location, nil] where the work happens, where it came back beside the job.
    def location = record Location, :location
  end
end
