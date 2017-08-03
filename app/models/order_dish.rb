class OrderDish < ApplicationRecord
  enum status: %i(no_need needing cooking cooked served cancel).freeze

  belongs_to :order
  belongs_to :dish

  has_many :history_items, dependent: :destroy, foreign_key: "item_id"

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :dish_present
  validate :order_present

  before_save :finalize

  after_update_commit{MessageBroadcastJob.perform_now describe}
  after_create_commit{save_history "create_new"}
  after_update_commit{save_history "add"}
  after_destroy_commit{save_history "remove"}

  load_order_dishes = lambda do |id|
    order_dishes = []
    where("order_id=?", id).pluck(:dish_id, :quantity)
      .map do |dish_id, quantity|
        order_dish = {quantity: quantity.to_s, dish_id: dish_id.to_s}
        order_dishes.push order_dish
      end
    order_dishes
  end

  scope :load_order_dishes, load_order_dishes

  def find_discount
    DiscountDish.new(self).discount
  end

  def total_price
    price * quantity * (100 - find_discount) / 100
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

  def save_history brand
    brand = "cancel" if cancel?
    HistoryItem.create item_id: id, brand: brand, describe: quantity,
      time: created_at, class_name: self.class.name
  end
end
