class AddColumnsToOrderCombos < ActiveRecord::Migration[5.0]
  def change
    add_column :order_combos, :discount, :integer
    add_column :order_combos, :quantity, :integer
    add_column :order_combos, :price, :float
    add_column :order_combos, :total_price, :float
  end
end
