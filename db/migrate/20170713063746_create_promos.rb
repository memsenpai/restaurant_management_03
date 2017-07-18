class CreatePromos < ActiveRecord::Migration[5.0]
  def change
    create_table :promos do |t|
      t.integer :dish_id, foreign_key: true
      t.integer :discount, default: 0
      t.datetime :start_day
      t.datetime :end_day
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
