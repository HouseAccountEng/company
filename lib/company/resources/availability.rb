module Company
  # One window the business is free to be booked into.
  class Availability < Resource
    # A window's half of the calendar is the one it opens on.
    def self.window = :starts_at

    # @return [Time, nil] when the window opens.
    def starts_at = time :starts_at

    # @return [Time, nil] when the window closes.
    def ends_at = time :ends_at

    # @return [Boolean, nil] whether the window is still free.
    def available? = attribute :available

    # @return [Array<Employee>] who could take the window, where they came back with it.
    def employees = records Employee, :employees
  end
end
