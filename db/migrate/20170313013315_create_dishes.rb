class CreateDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :dishes do |table|
      table.string :name
      table.string :description
      table.boolean :is_available

      table.timestamps
    end
  end
end
