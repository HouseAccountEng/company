module Company
  # The platform will not take the credentials: the grant itself is dead, not the request.
  class Refused < Error
  end
end
