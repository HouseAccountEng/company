module Company
  # Somebody who asked for work and is not a customer yet.
  class Lead < Resource
    include Person, Timestamped

    # @return [String, nil] where the lead came from.
    def source = attribute :source

    # @return [String, nil] where the lead stands in the business's pipeline.
    def status = attribute :status

    # @return [String, nil] what the lead asked for, in their words.
    def notes = attribute :notes

    # @return [Location, nil] where the work would happen.
    def location = record Location, :location
  end
end
