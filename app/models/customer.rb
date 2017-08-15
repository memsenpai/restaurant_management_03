class Customer < ApplicationRecord
  include Encode

  ATTRIBUTES = [
    :name, :email, :phone_num, :code,
    membership_attributes: %i(customer_id point total_point vip).freeze
  ].freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ratyrate_rater
  has_many :orders, dependent: :destroy
  has_many :bills
  has_one :membership

  validates :name, presence: true,
    length: {maximum: Settings.validates.name.maximum}
  validates :email, presence: true,
    length: {maximum: Settings.validates.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :warning_times, presence: true,
    numericality: {greater_than: Settings.validates.blacklist.greater_than}

  after_create_commit ->{create_membership}
  after_save :generate_code

  accepts_nested_attributes_for :membership, update_only: true

  def is_blacklist?
    warning_times > Settings.warning_times
  end

  def increase_warning
    update_attributes warning_times: warning_times + 1
  end
end
