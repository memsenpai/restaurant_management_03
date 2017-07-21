class CreateOrderDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :order_dishes do |t|
      t.integer :order_id
      t.integer :dish_id
      t.integer :discount
      t.integer :quantity
      t.integer :price
      t.integer :total_price
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
