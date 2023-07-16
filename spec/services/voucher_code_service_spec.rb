# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoucherCodeService do
  context 'no conflicts/duplicates arise' do
    let(:codes) { %w[43eed2dabb badeb46d5f c7a845984e fa6c0c6f99 ade85a6bf8] }
    let(:vouchers) do
      %w[f89e43ac0c 59ca3fada6 6f5f04d453 464b339d03 5a253914a9].map do |vc|
        VoucherCode.new(code: vc, valid_until: nil)
      end
    end
    subject { VoucherCodeService.new(vouchers.map(&:code), codes) }

    it 'returns 0 as number of duplicates' do
      expect(subject.number_of_duplicates).to eq(0)
    end
  end

  context 'conflicts/duplicates arise' do
    let(:codes) { %w[43eed2dabb badeb46d5f c7a845984e fa6c0c6f99 ade85a6bf8] }
    let(:vouchers) do
      %w[43eed2dabb 59ca3fada6 6f5f04d453 464b339d03 5a253914a9].map do |vc|
        VoucherCode.new(code: vc, valid_until: nil)
      end
    end
    subject { VoucherCodeService.new(vouchers.map(&:code), codes) }

    it 'returns 0 as number of duplicates' do
      expect(subject.number_of_duplicates).to eq(1)
    end
  end
end
