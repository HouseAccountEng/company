module Company
  # A person the business works for.
  class Customer < Resource
    include Person, Timestamped

    # @return [String, nil] the business the customer is, where the customer is a business.
    def company_name = @attributes[:company_name]

    # @return [String, nil] the person's name, or the business's where the person has none.
    def name = super || company_name.presence

    # @return [Relation] the places the customer has work done at.
    def locations = @company.locations.where customer_id: id

    # @return [Relation] the work the customer has had done, or booked.
    def jobs = @company.jobs.where customer_id: id

    # @return [Relation] the bills the customer was issued.
    def invoices = @company.invoices.where customer_id: id
  end
end
