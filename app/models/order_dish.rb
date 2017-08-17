class OrderDish < ApplicationRecord
  enum status: %i(no_need needing cooking cooked served cancel).freeze
  ATTRIBUTES = [
    :dish_id, :order_id, :quantity, :status,
    reasons_attributes: %i(describe staff_id).freeze
  ].freeze

  belongs_to :order
  belongs_to :dish

  has_many :history_items, dependent: :destroy, foreign_key: :item_id
  has_many :reasons, as: :item

  accepts_nested_attributes_for :reasons

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :dish_present
  validate :order_present

  before_save :finalize

  after_update_commit{MessageBroadcastJob.perform_now describe}
  after_create_commit{save_history "create_new"}
  after_update_commit{save_history "updated"}
  after_destroy_commit{save_history "remove"}
  after_commit :merge_duplication

  load_order_dishes = lambda do |id|
    order_dishes = []
    where("order_id=?", id).pluck(:dish_id, :quantity)
      .map do |dish_id, quantity|
        order_dish = {quantity: quantity.to_s, dish_id: dish_id.to_s}
        order_dishes.push order_dish
      end
    order_dishes
  end

  created_at_between = lambda do |datefrom, dateto|
    where(created_at: datefrom..dateto)
  end

  order_by_total_quantity = lambda do |order_by|
    select("dish_id, sum(quantity) as total_quantity")
      .group(:dish_id)
      .order("total_quantity #{order_by}")
  end

  first_order_dish = lambda do |dish_id, order_id|
    where "dish_id = ? AND
      order_id = ? AND status < 2", dish_id, order_id
  end

  duplication_obj = lambda do |order_dish|
    where order_id: order_dish.order_id, dish_id: order_dish.dish_id,
      status: order_dish.status
  end

  scope :load_order_dishes, load_order_dishes
  scope :first_order_dish, first_order_dish
  scope :order_by_total_quantity, order_by_total_quantity
  scope :created_at_between, created_at_between
  scope :duplication_obj, duplication_obj

  def find_discount
    DiscountDish.new(self).discount
  end

  def total_price
    price * quantity * (100 - find_discount) / 100
  end

  def filter_reasons
    describe = ""
    reasons.map do |reason|
      describe << I18n.t("cancel_tooltip", time: reason.created_at.utc.to_s,
        describe: reason.describe, staff: reason.staff.name)
    end
    describe
  end

  private

  def dish_present
    errors.add :dish, I18n.t("order.not_valid_or_not_active") unless dish
  end

  def order_present
    errors.add :order, I18n.t("order.not_valid_value") unless order
  end

  def finalize
    self[:price] = dish.price
    self[:total_price] = quantity * self[:price]
  end

  def describe
    table = order.table

    return unless table
    {dish: dish.name, table: table.code, status: status}
  end

  def save_history brand, describe = quantity
    brand = "cancel" if cancel?
    unless no_need?
      describe = I18n.t "descripbe_history_item",
        status: status, quantity: quantity
    end
    HistoryItem.create item_id: id, brand: brand, describe: describe,
      time: Time.now.in_time_zone, class_name: self.class.name
  end

  def merge_duplication
    OrderDish.duplication_obj(self).map do |item|
      next if item.id == id || item.reasons
      quantity = self.quantity + item.quantity
      OrderDish.delete self
      item.update_attributes quantity: quantity
    end
  end
end
