class AddColumnsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :day, :date
    add_column :orders, :is_confirm, :boolean, default: false
    add_column :orders, :discount, :integer, default: 0
    add_column :orders, :code, :string
  end
end
