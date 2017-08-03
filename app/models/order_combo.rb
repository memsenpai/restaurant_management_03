class OrderCombo < ApplicationRecord
  enum status: %i(no_need needing cooking cooked served cancel).freeze

  belongs_to :order
  belongs_to :combo

  has_many :history_items, dependent: :destroy, foreign_key: :item_id

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :combo_present
  validate :order_present

  before_save :finalize

  after_update_commit{MessageBroadcastJob.perform_now describe}
  after_create_commit{save_history "create_new"}
  after_update_commit{save_history "updated"}
  after_destroy_commit{save_history "remove"}

  load_order_combos = lambda do |id|
    order_combos = []
    where("order_id=?", id).pluck(:combo_id, :quantity)
      .map do |combo_id, quantity|
        order_combo = {quantity: quantity.to_s, combo_id: combo_id.to_s}
        order_combos.push order_combo
      end
    order_combos
  end

  created_at_between = lambda do |datefrom, dateto|
    where(created_at: datefrom..dateto)
  end

  order_by_total_quantity = lambda do |order_by|
    select("combo_id, sum(quantity) as total_quantity")
      .group(:combo_id)
      .order("total_quantity #{order_by}")
  end

  first_order_combo = lambda do |combo_id, order_id|
    where "combo_id = ? AND
      order_id = ? AND status < 2", combo_id, order_id
  end

  scope :load_order_combos, load_order_combos
  scope :first_order_combo, first_order_combo
  scope :created_at_between, created_at_between
  scope :order_by_total_quantity, order_by_total_quantity

  def original_price
    combo.subtotal
  end

  def total_price
    price * quantity
  end

  private

  def combo_present
    errors.add :combo, I18n.t("order.not_valid_or_not_active") unless combo
  end

  def order_present
    errors.add :order, I18n.t("order.not_valid_value") unless order
  end

  def finalize
    self[:price] = combo.price
    self[:total_price] = quantity * self[:price]
  end

  def describe
    table = order.table

    return unless table
    {combo: combo.name, table: table.code, status: status}
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
end
