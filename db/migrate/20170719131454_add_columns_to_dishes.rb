class AddColumnsToDishes < ActiveRecord::Migration[5.0]
  def change
    add_column :dishes, :price, :float
    add_column :dishes, :image, :string
  end
end
