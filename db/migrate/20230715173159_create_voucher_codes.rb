class CreateVoucherCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :voucher_codes do |t|
      t.string :code
      t.date :valid_until
      t.datetime :claimed_at

      t.timestamps
    end
  end
end
