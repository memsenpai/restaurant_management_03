class CreateBillDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_details do |t|
      t.integer :id_item
      t.integer :quantity
      t.integer :discount
      t.integer :price
      t.integer :item_type
      t.integer :bill_id

      t.timestamps
    end
  end
end
