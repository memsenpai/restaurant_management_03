class CreateOrderDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :order_dishes do |table|
      table.integer :order_id, foreign_key: true
      table.integer :dish_id, foreign_key: true
      table.integer :status, default: 0

      table.timestamps
    end
  end
end
