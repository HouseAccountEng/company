module Company
  # Extends a record a platform lets go untitled: a visit, a job, anything somebody may have
  # opened without ever typing a name for it.
  module Named
    # @return [String, nil] what whoever opened the record called it.
    def title = attribute :title

    # Untitled happens often enough, and something has to stand in for it on a list.
    # @return [String, nil] the title, or the ID the record is filed under.
    def name = title.presence || id
  end
end
