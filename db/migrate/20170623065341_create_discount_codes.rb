class CreateDiscountCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_codes do |table|
      table.string :code
      table.integer :discount
      table.string :status

      table.timestamps
    end
  end
end
