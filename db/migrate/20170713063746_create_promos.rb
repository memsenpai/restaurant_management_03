class CreatePromos < ActiveRecord::Migration[5.0]
  def change
    create_table :promos do |table|
      table.integer :dish_id, foreign_key: true
      table.integer :discount, default: 0

      table.timestamps
    end
  end
end
