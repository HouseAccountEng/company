module Acme
  # The jobs on the books: one done and paid, won with a quote and described; one booked ahead,
  # undescribed and unquoted, for a business that goes by its own name.
  class Jobs < Company::Collection
    NODES = [
      { id: 'job-1', description: 'Fix the sink', notes: 'Ring twice', created_at: 2.months.ago,
        scheduled_at: 1.month.ago, completed_at: 1.month.ago + 2.hours, amount: '260.0',
        quote: { id: 'quote-1', amount: '240.0' },
        lines: [ { id: 'line-1', name: 'Faucet', description: 'Replace washers', quantity: 3.0,
                   amount: '180.0', },
                 { id: 'line-2', name: 'Trip fee', quantity: 1.0, amount: '80.0' }, ],
        location: { id: 'location-1', street: '1 Main St', city: 'Raleigh', zip: '27601',
                    latitude: 35.77, longitude: -78.63,
                    customer: { id: 'customer-1', name: 'Jane', surname: 'Doe',
                                email: 'jane@example.com', phone: '(555) 333-5555', }, }, },
      { id: 'job-2', description: nil, notes: nil, created_at: 1.day.ago,
        scheduled_at: 3.days.from_now, completed_at: nil, amount: '0.0', quote: nil, lines: [],
        location: { id: 'location-2', street: '2 Main St', city: 'Raleigh', zip: '27601',
                    latitude: 35.78, longitude: -78.64,
                    customer: { id: 'customer-2', name: 'Acme Property Management', surname: nil,
                                email: nil, phone: '5554446666', }, }, },
    ]

    def initialize(from: nil, to: nil)
      @from = from
      @to = to
    end

    def each
      NODES.each { |node| yield Company::Job.new node: node if (@from..@to).cover? node[:scheduled_at] }
    end

    def between(from, to) = self.class.new(from: from, to: to)
  end
end
