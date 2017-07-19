class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |table|
      table.string :name
      table.string :description

      table.timestamps
    end
  end
end
