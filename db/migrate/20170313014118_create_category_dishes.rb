class CreateCategoryDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :category_dishes do |table|
      table.integer :category_id, foreign_key: true
      table.integer :dish_id, foreign_key: true

      table.timestamps
    end
  end
end
