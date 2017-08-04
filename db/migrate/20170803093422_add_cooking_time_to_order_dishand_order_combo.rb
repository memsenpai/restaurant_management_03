class AddCookingTimeToOrderDishandOrderCombo < ActiveRecord::Migration[5.0]
  def change
    add_column :order_dishes, :cooking_time, :datetime, default: Time.current
    add_column :order_combos, :cooking_time, :datetime, default: Time.current
  end
end
