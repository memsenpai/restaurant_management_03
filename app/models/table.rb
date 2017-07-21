class Table < ApplicationRecord
  has_many :orders, dependent: :destroy

  find_table = lambda do |capacity, day, hour_end, hour_start|
    where(
      "capacity >= ? AND id NOT IN (?)", capacity, Order.where(
        "day = ? AND time(time_in) < time(?)
        AND time(time_in) > time(?)", day, hour_end, hour_start
      ).select("table_id")
    )
  end

  scope :find_table, find_table
end
