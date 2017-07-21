class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.integer :customer_id
      t.integer :order_id
      t.integer :discount

      t.timestamps
    end
  end
end
