class CreateHistoryOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :history_orders do |t|
      t.integer :order_id
      t.datetime :time
      t.integer :brand
      t.integer :item_id
      t.text :describe

      t.timestamps
    end
  end
end
