class Bill < ApplicationRecord
  has_many :bill_details

  belongs_to :guest
  belongs_to :order

  validates :guest, presence: true
  validates :order, presence: true
  validates :discount, presence: true, numericality: {only_integer: true}

  def total
    total_price_bill_details * (100 - discount) / 100
  end

  def total_price_bill_details
    total = 0
    bill_details.each do |bill_detail|
      total += bill_detail.total_price
    end
    total
  end
end
