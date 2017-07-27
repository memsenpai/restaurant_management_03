class MembershipCoupon < ApplicationRecord
  enum status: %i(active notactive).freeze

  has_many :membership_coupon_histories

  validates :name, presence: true,
    length: {maximum: Settings.validates.name.maximum}
  validates :money_paid, presence: true,
    numericality: {
      only_integer: true,
      greater_than: Settings.validates.greater_than
    }
  validates :discount, presence: true,
    numericality: {
      only_integer: true,
      greater_than: Settings.validates.greater_than
    }

  coupon_max = lambda do |customer_money_paid|
    where("money_paid <= ?", customer_money_paid).map(&:money_paid)
  end

  scope :coupon_max, coupon_max
end
