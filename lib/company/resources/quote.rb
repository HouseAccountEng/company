module Company
  # A price the business sent to answer a lead.
  class Quote < Resource
    # What every quote reads, by the vocabulary's names.
    def self.attributes = %i[id lead_id]

    # @return [String, nil] ID of the lead the quote answers.
    def lead_id = attribute :lead_id
  end
end
