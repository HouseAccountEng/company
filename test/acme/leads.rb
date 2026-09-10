module Acme
  # Leads filed as they arrive: every word taken, and a customer opened with each.
  class Leads < Company::Leads
    def create(name:, surname:, phone:, email:, address:, description:, notes:, source:)
      Company::Lead.new node: { id: 'lead-1', description: description, notes: notes,
                                source: source, address: address,
                                customer: { id: 'customer-3', name: name, surname: surname,
                                            phone: phone, email: email, }, }
    end
  end
end
