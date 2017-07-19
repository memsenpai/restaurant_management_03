class CreateComboDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :combo_dishes do |table|
      table.integer :combo_id, foreign_key: true
      table.integer :dish_id, foreign_key: true

      table.timestamps
    end
  end
end
