module Company
  # Extends a record that is a document of lines: a quote, a job, an invoice.
  module Itemized
    # A line is part of the document it is on rather than a record of the account's, so the
    # lines come with the document or not at all.
    # @return [Array<Line>] the lines the record is made of, empty where none came back.
    def lines = records Line, :lines

    # @return [BigDecimal, Float, nil] what the lines add up to, in dollars.
    def total = @attributes[:total]
  end
end
