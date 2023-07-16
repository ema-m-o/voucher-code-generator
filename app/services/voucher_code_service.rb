# frozen_string_literal: true

class VoucherCodeService
  def initialize(unclaimed, codes = [])
    @codes = codes
    @unclaimed = unclaimed
  end

  def create_code
    SecureRandom.hex(10)
  end

  def batch_create(size)
    return @codes if @codes.size == size

    @codes << create_code
    @codes.uniq!
    @codes -= @unclaimed unless number_of_duplicates.zero?
    batch_create(size)
  end

  def number_of_duplicates
    @codes.size - (@codes - @unclaimed).size
  end
end
