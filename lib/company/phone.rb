module Company
  # The ten digits a North American number is, whatever punctuation it arrived wearing.
  class Phone
    # Ten digits whose area code and exchange open with 2 through 9.
    NANP = /\A[2-9]\d{2}[2-9]\d{6}\z/

    # @param number [String, nil] the number as the platform holds it.
    # @return [String, nil] the ten digits to dial, or nil where none was held.
    # @raise [Error] where a number was held and it is not a North American one.
    def self.from(number)
      return if number.blank?

      digits = number.delete('^0-9').delete_prefix '1'
      raise Error, "#{number} is not a North American number" unless NANP.match? digits

      digits
    end
  end
end
