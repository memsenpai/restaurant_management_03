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

  after_update_commit{MessageBroadcastJob.perform_now messages_data("update")}
  after_create_commit{MessageBroadcastJob.perform_now messages_data("create")}

  timein_between = lambda do |datefrom, dateto|
    where(day: datefrom..dateto)
  end

  order_by_timein = lambda do |order_by|
    select("time_in, count(time_in) as times")
      .group(:time_in)
      .order("time_in, times #{order_by}")
  end

  scope :timein_between, timein_between

  scope :order_by_timein, order_by_timein

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
      next 0 if order_combo.cancel?
      order_combo.valid? ? order_combo.quantity * order_combo.original_price : 0
    end
  end

  def original_dishes_map
    order_dishes.map do |order_dish|
      next 0 if order_dish.cancel?
      order_dish.valid? ? order_dish.quantity * order_dish.price : 0
    end
  end

  def subtotal_combos_map
    order_combos.map do |order_combo|
      next 0 if order_combo.cancel?
      order_combo.valid? ? order_combo.total_price : 0
    end
  end

  def subtotal_dishes_map
    order_dishes.map do |order_dish|
      next 0 if order_dish.cancel?
      order_dish.valid? ? order_dish.total_price : 0
    end
  end

  def validate_table
    datetime = DateTime.parse(day.to_s << " " << time_in.to_s).in_time_zone.utc
    errors.add :table unless Table.find_by(id: table_id).is_available? datetime
  end

  def messages_data action
    {
      action: action, name: customer.name, id: id, discount: discount,
      table_id: table_id, capacity: capacity,
      day: day.in_time_zone.strftime(I18n.t("date_default")),
      time_in: time_in, status: status
    }
  end
end
