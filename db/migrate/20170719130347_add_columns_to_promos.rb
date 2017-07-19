class AddColumnsToPromos < ActiveRecord::Migration[5.0]
  def change
    add_column :promos, :start_day, :datetime
    add_column :promos, :end_day, :datetime
    add_column :promos, :start_time, :datetime
    add_column :promos, :end_time, :datetime
  end
end
