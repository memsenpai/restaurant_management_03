class AddColumnPointToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :point, :integer, default: 0
  end
end
