class AddColumnsToOrderDishes < ActiveRecord::Migration[5.0]
  def change
    add_column :order_dishes, :discount, :integer
    add_column :order_dishes, :quantity, :integer
    add_column :order_dishes, :price, :float
    add_column :order_dishes, :total_price, :float
  end
end
