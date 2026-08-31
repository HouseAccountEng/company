module Company
  # What every error a company raises descends from, so one rescue still catches the lot.
  class Error < StandardError
  end
end
