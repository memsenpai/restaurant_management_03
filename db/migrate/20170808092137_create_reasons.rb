class CreateReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :reasons do |t|
      t.integer :item_id
      t.string :item_type
      t.text :describe
      t.integer :staff_id

      t.timestamps
    end
  end
end
