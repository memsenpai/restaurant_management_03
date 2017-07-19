class CreateOrderCombos < ActiveRecord::Migration[5.0]
  def change
    create_table :order_combos do |table|
      table.integer :order_id, foreign_key: true
      table.integer :combo_id, foreign_key: true
      table.integer :status, default: 0

      table.timestamps
    end
  end
end
