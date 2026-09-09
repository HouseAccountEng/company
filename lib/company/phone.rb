module Company
  # The ten digits a North American number is, whatever punctuation it arrived wearing.
  class Phone
    # Ten digits whose area code and exchange open with 2 through 9.
    NANP = /\A[2-9]\d{2}[2-9]\d{6}\z/

    # @param number [String, nil] number as the platform holds it.
    # @return [String, nil] ten digits to dial, or nil where none is held or none can be dialed.
    def self.from(number)
      digits = number.to_s.delete('^0-9').delete_prefix '1'
      digits if NANP.match? digits
    end
  end
end
