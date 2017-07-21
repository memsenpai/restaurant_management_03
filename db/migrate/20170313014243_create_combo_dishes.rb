class CreateComboDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :combo_dishes do |t|
      t.integer :combo_id
      t.integer :dish_id

      t.timestamps
    end
  end
end
