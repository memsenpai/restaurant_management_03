class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |table|
      table.integer :guest_id, foreign_key: true
      table.integer :table_id, foreign_key: true
      table.integer :time_in
      table.timestamps
    end
  end
end
