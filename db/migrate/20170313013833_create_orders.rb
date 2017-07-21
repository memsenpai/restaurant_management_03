class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :table_id
      t.string :code
      t.date :day
      t.integer :time_in
      t.boolean :is_confirm, default: false
      t.integer :discount, default: 0

      t.timestamps
    end
  end
end
