class Bill < ApplicationRecord
  ATTRIBUTES = %i(customer_id order_id discount membership_point).freeze

  has_many :bill_details

  belongs_to :customer
  belongs_to :order

  validates :customer, presence: true
  validates :order, presence: true
  validates :discount, presence: true, numericality: {only_integer: true}

  created_at_between = lambda do |datefrom, dateto|
    where(created_at: datefrom..dateto)
  end

  scope :created_at_between, created_at_between

  scope :in_month, ->(month){where("month(created_at) = (?)", month)}

  after_create_commit :order_done

  def total
    (total_price_bill_details * (100 - discount) / 100) - membership_point
  end

  def total_price_bill_details
    total = 0
    bill_details.each do |bill_detail|
      total += bill_detail.total_price
    end
    total
  end

  private

  def order_done
    order = Order.find_by id: order_id

    return unless order
    order.done!
    BillService.new(order).create_bill_info
  end
end
