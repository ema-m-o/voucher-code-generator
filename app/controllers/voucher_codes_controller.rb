# frozen_string_literal: true

class VoucherCodesController < ApplicationController
  def index
    return unless params[:show_valid] == 'true'

    @vouchers = VoucherCode.unclaimed.where('valid_until > ?', Date.today)
                           .or(VoucherCode.unclaimed.where(valid_until: nil))
  end

  def validate
    @voucher = VoucherCode.find_by_code(params[:code])
    redirect_to(voucher_codes_url, flash: {error: 'Voucher not found'}) and return unless @voucher

    if @voucher.valid_until.nil? || @voucher.valid_until > Date.today
      flash[:success] = 'Voucher found'
    else
      flash[:error] = "Voucher found, but seems to have expired on #{@voucher.valid_until}"
    end
    redirect_to(voucher_code_url(@voucher))
  end

  def show
    @voucher = VoucherCode.find(params[:id])
    index
    render 'index'
  end

  def update
    @voucher = VoucherCode.find(params[:id])
    @voucher.update!(claimed_at: Date.today)
    redirect_to(voucher_codes_url, flash: {success: 'Voucher marked as claimed.'})
  rescue ActiveRecord::RecordNotFound
    redirect_to(voucher_codes_url, flash: {error: 'Something went terribly wrong and the voucher was not found.'})
  end

  def create
    size = params[:number_of_codes].to_i
    codes = VoucherCodeService.new(VoucherCode.unclaimed.to_ary.map(&:code)).batch_create(size)
    VoucherCode.transaction do
      codes.each { |v| VoucherCode.new(code: v, valid_until: params[:valid_until]).save! }
    end
    redirect_to(voucher_codes_url('show_valid' => 'true'),
                flash: {success: 'It worked and your codes were created and saved.'})
  rescue ActiveRecord::ActiveRecordError
    redirect_to(voucher_codes_url,
                flash: {error: 'Something went terribly wrong and the voucher codes were not created.'})
  end

  private

  def voucher_code_params
    params.require(:voucher_code).permit(:code, :valid_until, :claimed_at, :show_valid, :number_of_codes)
  end
end
