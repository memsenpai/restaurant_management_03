class HistoryItem < ApplicationRecord
  enum brand: %i(create_new updated cancel remove).freeze

  belongs_to :order_combo
  belongs_to :order_dish

  validates :item_id, presence: true
end
