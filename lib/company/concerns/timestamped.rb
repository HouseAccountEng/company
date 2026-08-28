module Company
  # Extends a record the platform stamps as it is opened and changed.
  module Timestamped
    # @return [Time, nil] when the record was opened.
    def created_at = @attributes[:created_at]

    # @return [Time, nil] when the record last changed.
    def updated_at = @attributes[:updated_at]
  end
end
