class HistoryOrder < ApplicationRecord
  enum brand: %i(create_order update_order add_dish add_combo cancel_dish cancel_combo).freeze

  belongs_to :order
  validates :order_id, presence: true
end
