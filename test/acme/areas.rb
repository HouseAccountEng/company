module Acme
  # The map of the business: two areas, one of which covers a single ZIP code.
  class Areas < Company::Collection
    NODES = [ { id: 'area-1', name: 'Downtown', zips: %w[27601 27603] },
              { id: 'area-2', name: 'North Hills', zips: %w[27609] }, ]

    def each = NODES.each { |node| yield Company::Area.new node: node }
  end
end
