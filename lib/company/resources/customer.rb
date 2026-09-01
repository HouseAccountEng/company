module Company
  # A person the business works for.
  class Customer < Resource
    # What every customer reads, by the vocabulary's names.
    def self.attributes = %i[id first_name last_name]

    # @return [String, nil] their first name.
    def first_name = attribute :first_name

    # @return [String, nil] their last name.
    def last_name = attribute :last_name

    # @return [String] what they are called, by whichever of their names the company holds.
    def name = [ first_name, last_name ].compact.join ' '

    # @return [Enumerable<Location>] places on the customer's file, empty where none came back.
    def locations = records Location, :locations
  end
end
