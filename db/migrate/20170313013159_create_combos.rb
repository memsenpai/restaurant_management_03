class CreateCombos < ActiveRecord::Migration[5.0]
  def change
    create_table :combos do |table|
      table.string :description
      table.integer :discount

      table.timestamps
    end
  end
end
