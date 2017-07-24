class RemoveIsConfirmFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :is_confirm, :boolean
  end
end
