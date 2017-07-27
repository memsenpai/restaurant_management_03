class Order < ApplicationRecord
  include Encode

  enum status: %i(uncheck declined approved serving done).freeze
  ORDER_ATTRIBUTES = [
    :discount, :day, :time_in, :status,
    customer_attributes: %i(id name).freeze,
    table_attributes: %i(id capacity).freeze
  ].freeze

  belongs_to :customer
  belongs_to :table, inverse_of: :orders
  delegate :capacity, to: :table

  has_many :order_dishes, dependent: :destroy
  has_many :order_combos, dependent: :destroy
  has_one :bill

  delegate :code, to: :customer, prefix: :customer

  validate :validate_table, on: :create

  after_save :generate_code

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :table

  after_commit{MessageBroadcastJob.perform_now self}

  def subtotal
    subtotal_combos_map.sum + subtotal_dishes_map.sum
  end

  def original_price
    original_combos_map.sum + original_dishes_map.sum
  end

  def total_item
    order_combos.map(&:quantity).sum +
      order_dishes.map(&:quantity).sum
  end

  def change_status
    case status
    when "uncheck", "declined"
      "approved"
    when "approved"
      "serving"
    when "serving"
      "done"
    end
  end

  def price_final
    (subtotal * (100 - discount -
      customer.membership_discount)) / 100
  end

  private

  def original_combos_map
    order_combos.map do |order_combo|
      order_combo.valid? ? order_combo.quantity * order_combo.original_price : 0
    end
  end

  def original_dishes_map
    order_dishes.map do |order_dish|
      order_dish.valid? ? order_dish.quantity * order_dish.price : 0
    end
  end

  def subtotal_combos_map
    order_combos.map do |order_combo|
      order_combo.valid? ? order_combo.total_price : 0
    end
  end

  def subtotal_dishes_map
    order_dishes.map do |order_dish|
      order_dish.valid? ? order_dish.total_price : 0
    end
  end

  def validate_table
    datetime = DateTime.parse(day.to_s << " " << time_in.to_s).in_time_zone.utc
    errors.add :table unless Table.find_by(id: table_id).is_available? datetime
  end
end
