module Company
  # A person the business works for.
  class Customer < Resource
    # What every customer reads, by the vocabulary's names.
    def self.attributes = %i[id name surname email phone]

    # @return [String, nil] what they go by: a given name, or a business's where a person has none.
    def name = attribute :name

    # @return [String, nil] their surname.
    def surname = attribute :surname

    # @return [String, nil] address they are written to.
    def email = attribute :email

    # @return [String, nil] ten digits they are reached on, nil where none can be dialed.
    def phone = Phone.from attribute(:phone)
  end
end
