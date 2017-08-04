class Customer < ApplicationRecord
  include Encode
  ratyrate_rater
  has_many :orders, dependent: :destroy
  has_many :bills
  validates :name, presence: true,
    length: {maximum: Settings.validates.name.maximum}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.validates.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :warning_times, presence: true,
    numericality: {greater_than: Settings.validates.blacklist.greater_than}
  after_save :generate_code

  def membership_money_paid
    return 0 unless membership_current
    membership_current.money_paid
  end

  def membership_discount
    return 0 unless membership_current
    membership_current.discount
  end

  def membership_current
    money_paids = MembershipCoupon.coupon_max money_paid
    MembershipCoupon.find_by money_paid: money_paids.max
  end

  def is_blacklist?
    warning_times > Settings.warning_times
  end

  def increase_warning
    update_attributes warning_times: warning_times + 1
  end
end
