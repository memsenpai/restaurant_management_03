class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :tables do |table|
      table.integer :capacity
      table.string :code

      table.timestamps
    end
  end
end
