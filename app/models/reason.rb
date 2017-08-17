class Reason < ApplicationRecord
  ATTRIBUTES = %i(item_id item_type describe).freeze
  belongs_to :item, polymorphic: true
  belongs_to :staff

  validates :item_id, presence: true
  validates :describe, presence: true
end
