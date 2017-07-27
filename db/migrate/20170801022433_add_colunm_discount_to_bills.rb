class AddColunmDiscountToBills < ActiveRecord::Migration[5.0]
  def change
    add_column :bills, :membership_discount, :integer, default: 0
    change_column :bills, :discount, :integer, default: 0
  end
end
