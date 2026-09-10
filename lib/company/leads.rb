module Company
  # The leads of a business: who asked it for work, before there is a job. A gem answers
  # `create` with the lead its platform filed, dropping what the platform has no field for.
  class Leads
    # @param name [String] given name of who asked, or the business's where a person has none.
    # @param surname [String, nil] their surname.
    # @param phone [String, nil] number they are reached on.
    # @param email [String, nil] address they are written to.
    # @param address [Hash, nil] where the work would happen: :street, :city, :state and :zip.
    # @param description [String] what the work is called.
    # @param notes [String, nil] what else was said about it.
    # @param source [String, nil] where the lead came from, as the business names its sources.
    # @return [Lead] the lead as the platform filed it.
    def create(name:, surname:, phone:, email:, address:, description:, notes:, source:)
      raise NotImplementedError, "#{self.class} does not file a lead"
    end
  end
end
