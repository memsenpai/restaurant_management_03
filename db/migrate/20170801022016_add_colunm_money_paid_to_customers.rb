class AddColunmMoneyPaidToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :money_paid, :integer, default: 0
  end
end
