module Company
  # Extends a record that is somebody: a customer, an employee, a lead.
  module Person
    # @return [String, nil] their first name.
    def first_name = attribute :first_name

    # @return [String, nil] their last name.
    def last_name = attribute :last_name

    # @return [String, nil] what they are called, by whichever of their names the company holds.
    def name = [ first_name, last_name ].compact_blank.join(' ').presence

    # @return [String, nil] the address to write to.
    def email = attribute :email

    # @return [String, nil] the number to reach them on, as ten digits.
    def phone = attribute :phone
  end
end
