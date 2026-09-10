module Company
  # Raised where a platform holds a request to a rate: the same question asked a little later
  # is answered. Nothing here sleeps; a caller with a queue brings the whole job back.
  class Throttled < Error
  end
end
