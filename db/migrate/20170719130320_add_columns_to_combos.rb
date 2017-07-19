class AddColumnsToCombos < ActiveRecord::Migration[5.0]
  def change
    add_column :combos, :name, :string
    add_column :combos, :image, :string
    add_column :combos, :from, :datetime
    add_column :combos, :to, :datetime
  end
end
