class AddColunmWarningTimesToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :warning_times, :integer, default: 0
  end
end
