class ChangeColumnBill < ActiveRecord::Migration[5.0]
  def change
    rename_column :bills, :membership_discount, :membership_point
  end
end
