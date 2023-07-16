# frozen_string_literal: true

class VoucherCode < ApplicationRecord
  scope :unclaimed, -> { where(claimed_at: nil) }
end
