class CreateHistoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :history_items do |t|
      t.integer :item_id
      t.datetime :time
      t.integer :brand
      t.text :describe
      t.string :class_name

      t.timestamps
    end
  end
end
