module Company
  # Work the business accepted and scheduled.
  class Job < Resource
    # What every job reads, by the vocabulary's names.
    def self.attributes
      %i[id quote_id quote_amount description instructions created_at scheduled_at completed_at
         amount]
    end

    # @return [String, nil] ID of the quote the job was won with.
    def quote_id = attribute :quote_id

    # @return [BigDecimal, nil] what that quote came to, in dollars.
    def quote_amount = decimal :quote_amount

    # @return [String, nil] what whoever opened the job asked the crew to mind.
    def instructions = attribute :instructions

    # The lines say what the work was where a description only says what it was called.
    # @return [String] lines as a sentence, or the description, or the ID.
    def summary = lines.to_sentence.presence || description.presence || id

    # @return [Time] moment the job was opened.
    def created_at = time :created_at

    # @return [Time, nil] moment the work is booked for.
    def scheduled_at = time :scheduled_at

    # @return [Time, nil] moment the work was finished.
    def completed_at = time :completed_at

    # @return [BigDecimal, nil] what the job comes to, in dollars.
    def amount = decimal :amount

    # @return [Array<Line>] lines the work is billed as, empty where none came back.
    def lines = records Line, :lines

    # @return [Location, nil] where the work happens, where it came back beside the job.
    def location = record Location, :location

  private

    def description = attribute :description
  end
end
