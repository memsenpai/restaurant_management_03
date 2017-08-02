class CreateMembershipCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :membership_coupons do |t|
      t.integer :money_paid, default: 0
      t.string :name
      t.integer :discount
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
